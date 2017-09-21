//
//  SyncedSmartAssistantInterfaceController.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 14/03/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import RxSwift
import WatchConnectivity
import WatchKit

class SyncedSmartAssistantInterfaceController: WKInterfaceController, SmartAssistantInterfaceControllable, PlaySound {
  @IBOutlet var infoLabel: WKInterfaceLabel!
  @IBOutlet var startButton: WKInterfaceButton!
  @IBOutlet var timer: WKInterfaceTimer!

  var disposeBag: DisposeBag = DisposeBag()

  var viewModel: SyncedSmartAssistantViewModel<ProcessedData>!

  override func awake(withContext context: Any?) {
    viewModel = SyncedSmartAssistantViewModel(frequency: 100)
  }

  @IBAction func startButtonAction() {
    startAssistant()
  }

  @IBAction func startWorkoutSessionAction() {
    startWorkoutSession()
  }

  @IBAction func stopWorkoutSessionAction() {
    stopWorkoutSession()
  }
}
