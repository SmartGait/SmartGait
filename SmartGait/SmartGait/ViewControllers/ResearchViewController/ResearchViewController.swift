//
//  ResearchViewController.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 14/03/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import AudioToolbox
import AVFoundation
import RxCocoa
import RxSwift
import UIKit
import WatchConnectivity

class ResearchViewController: UIViewController {

  @IBOutlet weak var titleLabel: UILabel!
  fileprivate let taskIsFinished = Variable<Bool>(false)
  fileprivate let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
  fileprivate let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)

  var viewModel: ShortWalkViewModel!

  var audioPlayer: AVAudioPlayer?
  var disposeBag: DisposeBag!
  var stopCurrentStep = PublishSubject<Bool>()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupAudioPlayer()
    //testVC()
  }

  func setupAudioPlayer() {
    guard let dingSoundPath = Bundle.main.path(forResource: "beep", ofType: "mp3") else {
      return
    }

    let dingSound = URL(fileURLWithPath: dingSoundPath)
    do {
      audioPlayer = try AVAudioPlayer(contentsOf: dingSound)
      audioPlayer?.volume = 1.0
      audioPlayer?.prepareToPlay()
    } catch {
      print("Error getting the audio file")
    }
  }

  func startTask(withStartTime startTime: StartTime, numberOfStepsPerLeg: Int, restDuration: TimeInterval) {
    viewModel = ShortWalkViewModel(
      identifier: "Gait",
      numberOfStepsPerLeg: numberOfStepsPerLeg,
      restDuration: restDuration,
      startTime: startTime
    )

    taskIsFinished.value = false
    disposeBag = nil
    disposeBag = DisposeBag()

    self.titleLabel.text = NSLocalizedString("Waiting", comment: "")

    let startTimer = setupStartTimer()
    startTimer
      .do(onNext: { _ in
        self.setupCurrentStep()
        self.setupTaskIsFinished()
      })
      .subscribe()
      .addDisposableTo(disposeBag)
  }

  private func setupStartTimer() -> Observable<Void> {
    return Observable<Int>.timer(viewModel.startTime.secondsLeft(), scheduler: MainScheduler.instance)
      .flatMap { _ -> Observable<Int> in
        self.titleLabel.text = String.localizedStringWithFormat(NSLocalizedString("StartingIn", comment: ""),
                                                                 Int(self.viewModel.startTimerDuration))
        return Observable<Int>
          .timer(self.viewModel.startTimerDuration, scheduler: MainScheduler.instance)
      }
      .do(onNext: { _ in
        self.titleLabel.text = NSLocalizedString("WillStart", comment: "")
      })
      .map(void)
  }

  private func setupCurrentStep() {
    let currentStep = viewModel
      .currentStep
      .asObservable()
      .map { $0?.value }

    currentStep
      .do(onNext: { (step) in
        if step == nil { // There are no more steps
          self.taskIsFinished.value = true
        }
      })
      .unwrap()     // If unwrapping succeeds, we haven't reached the end of the task
      .observeOn(MainScheduler.instance)
      .do(onNext: { (stepViewModel) in
        // Do  UI related stuff
        self.titleLabel.text = stepViewModel.description
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        self.audioPlayer?.play()
      })
      .observeOn(backgroundScheduler)
      .flatMap { Observable.from(optional: $0.collect(until: self.stopCurrentStep)) }
      .concat()
      .subscribe()
      .addDisposableTo(disposeBag)
  }

  private func setupTaskIsFinished() {
    taskIsFinished
      .asObservable()
      .filter { $0 }
      .observeOn(MainScheduler.instance)
      .do(onNext: { (_) in
        self.titleLabel.text = NSLocalizedString("Completed", comment: "")
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        self.titleLabel.text = NSLocalizedString("Saving", comment: "")
      })
      .observeOn(backgroundScheduler)
      .do(onNext: { (_) in
        self.saveTask()
      })
      .observeOn(MainScheduler.instance)
      .do(onNext: { (_) in
        self.titleLabel.text = NSLocalizedString("EndedSaving", comment: "")
        self.disposeBag = nil
      })
      .subscribe()
      .addDisposableTo(disposeBag)
  }

  func startNextStep(at startTime: StartTime) {
    stopCurrentStep.onNext(true)

    Observable<Int>
      .timer(startTime.secondsLeft(), scheduler: MainScheduler.instance)
      .do(onNext: { _ in
        self.viewModel.nextStep()
      })
      .subscribe()
      .addDisposableTo(disposeBag)
  }

  func saveTask() {
    let task = self.viewModel.finish()
    CoreDataManager.sharedInstance.saveToCoreData(task: task)
  }
}

extension ResearchViewController {
  func testVC() {
    let startTime = StartTime(time: 0)

    let shortWalk = ShortWalk(startTime: startTime, numberOfStepsPerLeg: 5, restDuration: 5)

    startTask(withStartTime: shortWalk.startTime ?? StartTime(time: 0),
              numberOfStepsPerLeg: shortWalk.numberOfStepsPerLeg,
              restDuration: shortWalk.restDuration)

    Observable<Int>.timer(1.5 * 5.0, period: 1.5 * 5.0, scheduler: MainScheduler.instance)
      .do(onNext: { _ in
        self.startNextStep(at: startTime)
      })
      .take(3)
      .subscribe()
      .addDisposableTo(rx_disposeBag)
  }
}
