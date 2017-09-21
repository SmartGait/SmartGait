//
//  ShortWalkInterfaceController.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 03/02/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import AVFoundation
import Foundation
import RxCocoa
import RxSwift
import WatchConnectivity
import WatchKit

class ShortWalkInterfaceController: WKInterfaceController, PlaySound {
  private var viewModel: ShortWalkViewModel!

  @IBOutlet var titleLabel: WKInterfaceLabel!
  @IBOutlet var timer: WKInterfaceTimer!

  fileprivate var isReachable = Variable<Bool?>(nil)
  fileprivate let taskIsFinished = Variable<Bool?>(nil)

  fileprivate var sessionManager: WCSessionManager?
  private let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)

  private let startTask = Variable(false)

  private var disposeBag: DisposeBag! = DisposeBag()

  private var startTimer: Observable<Void>!

  override func awake(withContext context: Any?) {
    super.awake(withContext: context)

    viewModel = context as? ShortWalkViewModel

    do {
      self.sessionManager = try WCSessionManager.sharedInstanceFunc()
    } catch let error {
      print(error)
    }

    guard let sessionManager = sessionManager else {
      return
    }

    let isReachable = sessionManager.isReachable()
      .filter { $0 }

    startTimer = setupStartTime(isReachable: isReachable)

    startTimer
      .asObservable()
      .do(onNext: { _ in
        self.setupCurrentStep()
        self.setupTaskIsFinished()
      })
      .debug()
      .subscribe()
      .addDisposableTo(disposeBag)

    sessionManager.session.rx.didFinishFileTransfer
      .asObservable()
      .observeOn(MainScheduler.instance)
      .do(onNext: { (result) in
        print(result)
        switch result {
        case .success:
          self.titleLabel.setText(NSLocalizedString("DataSent", comment:""))
        case .failure(let error):
          self.titleLabel.setText(error.description)
        }
      })
      .subscribe()
      .addDisposableTo(disposeBag)
  }

  override func willDisappear() {
    super.willDisappear()
    disposeBag = nil
    print("WILL DISAPPEAR")
  }

  private func setupStartTime(isReachable: Observable<Bool>) -> Observable<Void> {
    isReachable
      .take(1)
      .observeOn(MainScheduler.instance)
      .do(onNext: { _ in
        let shortWalk = ShortWalk(startTime: self.viewModel.startTime,
                                  numberOfStepsPerLeg: self.viewModel.numberOfStepsPerLeg,
                                  restDuration: self.viewModel.restDuration)

        let message: [String: Any] = ["startShortWalk": shortWalk.toJSON()]

        self.sessionManager?.session.sendMessage(message, replyHandler: { (message) in
          log.info(message)
          print(message)
          self.startTask.value = true
        }, errorHandler: { (error) in
          log.info(error)
          print(error)
        })
      })
      .do(onNext: { (_) in
        let instruction = String.localizedStringWithFormat(NSLocalizedString("StartingIn", comment: ""),
                                                           Int(self.viewModel.startTimerDuration))
        self.play(spokenInstruction: instruction)
      })
      .map(void) 
      .debug()
      .subscribe()
      .addDisposableTo(disposeBag)

    return startTask
      .asObservable()
      .filter { $0 }
      .observeOn(backgroundScheduler)
      .flatMap { _ -> Observable<Int> in
        return Observable<Int>.timer(self.viewModel.startTime.secondsLeft(), scheduler: MainScheduler.instance)
      }
      .flatMap { _ -> Observable<Int> in
        self.timer.setDate(Date(timeIntervalSinceNow: self.viewModel.startTimerDuration))
        self.timer.start()

        return Observable<Int>
          .timer(self.viewModel.startTimerDuration, scheduler:  MainScheduler.instance)
      }
      .do(onNext: { _ in
        self.timer.setHidden(true)
      })
      .map(void)
  }

  private func setupCurrentStep() {
    let currentStep = viewModel.currentStep.asObservable()
      .map { $0?.value }

    //checks if there is no more steps
    currentStep
      .map { $0 == nil }
      .bind(to: taskIsFinished)
      .addDisposableTo(disposeBag)

    let updateUIWithCurrentStep = { (stepViewModel: StepViewModel) in
      self.titleLabel.setText(stepViewModel.description)
      WKInterfaceDevice.current().play(.start)
      self.play(spokenInstruction: stepViewModel.spokenInstruction)
    }

    let collectDataOnStep = { (stepViewModel: StepViewModel) in
      Observable.from(optional: stepViewModel.collect())
        .concat()
        .map(void)
//        .debug()
        .subscribe(self.sendStartNextStepMessage)
        .addDisposableTo(self.disposeBag)
    }

    currentStep
      .unwrap()
      .observeOn(MainScheduler.instance)
      .do(onNext: updateUIWithCurrentStep)
      .observeOn(backgroundScheduler)
      .do(onNext: collectDataOnStep)
//      .debug()
      .subscribe()
      .addDisposableTo(disposeBag)
  }

  func sendStartNextStepMessage(_: Event<Void>) {
    let startTime = StartTime(time: Date().addingTimeInterval(1).timeIntervalSince1970)

    let message: [String: Any] = ["startNextStep": startTime.toJSON()]

    self.sessionManager?.session.sendMessage(message, replyHandler: { (message) in
      print(message)
      self.startNextStep(at: startTime)
    }, errorHandler: { (error) in
      print(error)
    })
  }

  func startNextStep(at startTime: StartTime) {
    Observable<Int>.timer(startTime.secondsLeft(), scheduler: MainScheduler.instance)
      .do(onNext: { _ in
        self.viewModel.nextStep()
      })
      .subscribe()
      .addDisposableTo(disposeBag)
  }

  private func setupTaskIsFinished() {
    taskIsFinished
      .asObservable()
      .debug()
      .unwrap()
      .filter { $0 }
      .observeOn(MainScheduler.instance)
      .do(onNext: { (_) in
        self.titleLabel.setText("Completed")
        WKInterfaceDevice.current().play(.stop)
        self.play(spokenInstruction: NSLocalizedString("Completed", comment: ""))
      })
      .observeOn(backgroundScheduler)
      .subscribe(onNext: { _ in
        self.sendDataToiOS()
      })
      .addDisposableTo(disposeBag)
  }

  private func sendDataToiOS() {
    let task = viewModel.finish()
    self.titleLabel.setText(NSLocalizedString("SendingData", comment: ""))

    do {
      let fileURL = try saveDataToFile(task: task)

      DispatchQueue.main.async {
        self.sessionManager?.session.transferFile(fileURL, metadata: ["saveTask": ""])
      }
    } catch let error {
      self.titleLabel.setText("error")
      log.error(error)
    }
  }

  private func saveDataToFile(task: Task) throws -> URL {
    let fileName = "\(task.identifier)-\(task.startDate.description)-\(task.endDate.description)"
    let documentDirURL = try FileManager.default
      .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

    let fileURL = documentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")

    try task.toJSONString()?.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)

    return fileURL
  }
}
