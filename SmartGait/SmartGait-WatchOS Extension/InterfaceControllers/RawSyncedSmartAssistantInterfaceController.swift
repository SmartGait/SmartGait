//
//  RawSyncedSmartAssistantInterfaceController.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 03/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import WatchKit
import Foundation

import Foundation
import RxSwift
import WatchConnectivity
import WatchKit

//swiftlint:disable type_name
class RawSyncedSmartAssistantInterfaceController: WKInterfaceController, NonGenericSmartAssistantInterfaceControllable,
PlaySound {

  @IBOutlet var infoLabel: WKInterfaceLabel!
  @IBOutlet var startButton: WKInterfaceButton!
  @IBOutlet var timer: WKInterfaceTimer!

  @IBOutlet var sensitivitySlider: WKInterfaceSlider!

  var watchdog: Watchdog?

  var disposeBag: DisposeBag = DisposeBag()

  var backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)

  var viewModel: SyncedNonGenericSAViewModel! //SyncedSmartAssistantViewModel<RawData>!

  override func awake(withContext context: Any?) {
    viewModel = SyncedNonGenericSAViewModel(frequency: 50) //SyncedSmartAssistantViewModel(frequency: 50)
    sensitivitySlider.setValue(viewModel.sensitivity.value)
  }

  @IBAction func startButtonAction() {
    startAssistant()
  }

  @IBAction func startWorkoutSessionAction() {
    watchdog = Watchdog(threshold: 0.2, strictMode: true)
    startWorkoutSession()
  }

  @IBAction func stopWorkoutSessionAction() {
    stopWorkoutSession()
  }

  @IBAction func sliderAction(_ value: Float) {
    viewModel.sensitivity.value = value
  }
}
