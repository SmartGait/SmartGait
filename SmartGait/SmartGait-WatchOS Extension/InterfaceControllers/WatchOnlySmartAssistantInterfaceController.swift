//
//  WatchOnlySmartAssistantInterfaceController.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 22/04/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import WatchKit

//swiftlint:disable type_name
class WatchOnlySmartAssistantInterfaceController: WKInterfaceController,
SmartAssistantInterfaceControllable, PlaySound {

  @IBOutlet var infoLabel: WKInterfaceLabel!
  @IBOutlet var startButton: WKInterfaceButton!
  @IBOutlet var timer: WKInterfaceTimer!

  var disposeBag = DisposeBag()

  var viewModel: WatchOnlySmartAssistantViewModel!

  override func awake(withContext context: Any?) {
    viewModel = WatchOnlySmartAssistantViewModel(frequency: 100)
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

extension WatchOnlySmartAssistantInterfaceController {
  fileprivate func showClassification(dataClassification: DataClassification) {
    infoLabel.setText(dataClassification.classification.rawValue)
  }
}
