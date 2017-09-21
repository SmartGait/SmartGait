//
//  SmartAssistantInterfaceControllable.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 22/04/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreData
import Foundation
import RxSwift
import RxCocoa
import WatchKit

protocol SmartAssistantInterfaceControllable: class {
  associatedtype ViewModel: SmartAssistant

  var viewModel: ViewModel! { get set }
  var infoLabel: WKInterfaceLabel! { get set }
  var startButton: WKInterfaceButton! { get set }
  var timer: WKInterfaceTimer! { get set }
  var disposeBag: DisposeBag { get set }

  func startAssistant()
  func startWorkoutSession()
  func updateTimer(withTimerState timerState: TimerState)
}

extension SmartAssistantInterfaceControllable {

  func startAssistant() {
    self.startButton.setHidden(true)

    viewModel.startSmartAssistant()

    viewModel
      .timer
      .asObservable()
      .do(onNext: updateTimer)
      .subscribe()
      .addDisposableTo(disposeBag)

    viewModel
      .lastClassification
      .asObservable()
      .unwrap()
      .map { $0.dataClassification }
      .unwrap()
      .observeOn(MainScheduler.instance)
      .do(onNext: showClassification)
      .subscribe()
      .addDisposableTo(disposeBag)
  }

  func startWorkoutSession() {
    startButton.setHidden(true)
    let watchDelegate = WKExtension.shared().delegate as? ExtensionDelegate
    watchDelegate?.startWorkout()
    viewModel.resumeDataCollection()
  }

  func stopWorkoutSession() {
    let watchDelegate = WKExtension.shared().delegate as? ExtensionDelegate
    watchDelegate?.stopWorkout()
    infoLabel.setText("Paused")
    viewModel.pauseDataCollection()
  }

  func updateTimer(withTimerState timerState: TimerState) {
    switch timerState {
    case .started:
      self.timer.setDate(Date(timeIntervalSinceNow: self.viewModel.startTimerDuration))
      self.timer.start()
    case .ended:
      print("Should start \(Date().timeIntervalSince1970)")
      self.timer.setHidden(true)
      self.infoLabel.setText("Started")
    default:
      break
    }
  }

  func showClassification(dataClassification: DataClassification) {
    guard let classification = dataClassification.classification else {
      return
    }
    switch classification {
    case .imbalanced:
      WKInterfaceDevice.current().play(.notification)
    default:
      break
    }

    infoLabel.setText(dataClassification.classification.rawValue)
  }
}
