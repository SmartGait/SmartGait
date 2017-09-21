//
//  InterfaceController.swift
//  SmartGait-WatchOS Extension
//
//  Created by Francisco Gonçalves on 02/02/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import RxSwift
import WatchConnectivity
import WatchKit

class ResearchInterfaceController: WKInterfaceController {
  @IBOutlet var startButton: WKInterfaceButton!
  @IBOutlet var stepPicker: WKInterfacePicker!
  @IBOutlet var restTimePicker: WKInterfacePicker!

  fileprivate var sessionManager: WCSessionManager?

  fileprivate let stepPickerItems = [Int](1...100)
  fileprivate let restTimePickerItems = [Int](5...100)

  fileprivate let stepPickerSelectedItem = Variable<Int>(1)
  fileprivate let restTimePickerSelectedItem = Variable<Int>(5)

  override func awake(withContext context: Any?) {
    super.awake(withContext: context)

    do {
      self.sessionManager = try WCSessionManager.sharedInstanceFunc()
    } catch let error {
      print(error)
    }

    setupPickers()
  }

  private func setupPickers() {
    let stepItems = stepPickerItems.map { value -> WKPickerItem in
      let item = WKPickerItem()
      item.title = "\(value)"
      return item
    }

    let restItems = restTimePickerItems.map { value -> WKPickerItem in
      let item = WKPickerItem()
      item.title = "\(value)"
      return item
    }

    stepPicker.setItems(stepItems)
    stepPicker.setSelectedItemIndex(4)
    restTimePicker.setItems(restItems)
    restTimePicker.setSelectedItemIndex(0)
  }

  @IBAction func stepPickerItemChanged(_ value: Int) {
    stepPickerSelectedItem.value = stepPickerItems[value]
  }

  @IBAction func restPickerItemChanged(_ value: Int) {
    restTimePickerSelectedItem.value = restTimePickerItems[value]
  }

  @IBAction func startButtonAction() {
    let startTime = StartTime(time: Date().addingTimeInterval(2).timeIntervalSince1970)

    let viewModel = ShortWalkViewModel(identifier: "watchOS Gait",
                                       numberOfStepsPerLeg: stepPickerSelectedItem.value,
                                       restDuration: TimeInterval(restTimePickerSelectedItem.value),
                                       startTime: startTime)

    self.pushController(withName: "ShortWalkInterfaceController", context: viewModel)
  }

  @IBAction func stopWorkoutSession() {
    let watchDelegate = WKExtension.shared().delegate as? ExtensionDelegate
    watchDelegate?.stopWorkout()
  }

  @IBAction func startWorkoutSession() {
    let watchDelegate = WKExtension.shared().delegate as? ExtensionDelegate
    watchDelegate?.startWorkout()
  }
}
