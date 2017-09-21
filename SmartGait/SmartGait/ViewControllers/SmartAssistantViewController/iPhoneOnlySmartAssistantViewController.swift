//
//  iPhoneOnlyViewController.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 24/04/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreData
import RxCocoa
import RxSwift
import UIKit
import WatchConnectivity
import AVFoundation
import JSKTimerView
import AudioToolbox

//swiftlint:disable type_name
class iPhoneOnlySmartAssistantViewController: UIViewController {

  @IBOutlet weak var infoLabel: UILabel!
  @IBOutlet weak var startStopButton: UIButton!
  @IBOutlet weak var timer: JSKTimerView!

  fileprivate var viewModel: iPhoneOnlySmartAssistantViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel = iPhoneOnlySmartAssistantViewModel(frequency: 100)

    viewModel
      .lastClassification
      .asObservable()
      .unwrap()
      .observeOn(MainScheduler.instance)
      .do(onNext: showClassification)
      .subscribe()
      .addDisposableTo(rx_disposeBag)

    startStopButton
      .rx.tap
      .map { _ in self.startStopButton.currentTitle?.lowercased() }.unwrap()
      .map { StartStopAction(rawValue: $0) }.unwrap()
      .do(onNext: handle)
      .do(onNext: updateButtonTitle)
      .subscribe()
      .addDisposableTo(rx_disposeBag)
  }

  @IBAction func startButtonAction() {
    startAssistant()
  }
}

extension iPhoneOnlySmartAssistantViewController {
  fileprivate func showClassification(data: ClassifiableData) {
    guard let classification = data.dataClassification?.classification else {
      return
    }

    infoLabel.text = classification.rawValue

    if classification == .imbalanced {
      AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
  }

  fileprivate func updateTimer(withTimerState timerState: TimerState) {
    switch timerState {
    case .started:
      timer.isHidden = false
      timer.startTimer(withDuration: Int(viewModel.startTimerDuration))
    case .ended:
      print("Should start \(Date().timeIntervalSince1970)")
      timer.isHidden = true
      self.infoLabel.text = "Started"
    default:
      break
    }
  }
}

extension iPhoneOnlySmartAssistantViewController {
  func startAssistant() {
    viewModel.startSmartAssistant()

    viewModel
      .timer
      .asObservable()
      .do(onNext: updateTimer)
      .subscribe()
      .addDisposableTo(rx_disposeBag)
  }

  func stopAssistant() {
    timer.stopTimer()
    timer.isHidden = true
    viewModel.pauseDataCollection()
  }

  func handle(action: StartStopAction) {
    switch action {
    case .start:
      startAssistant()
    case .stop:
      stopAssistant()
    }
  }

  func updateButtonTitle(action: StartStopAction) {
    startStopButton.setTitle(action.nextState().rawValue.capitalized, for: .normal)
  }
}

enum StartStopAction: String {
  case start
  case stop

  func nextState() -> StartStopAction {
    switch self {
    case .start:
      return .stop
    case .stop:
      return .start
    }
  }
}
