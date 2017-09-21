//
//  SmartAssistant.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 22/04/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol SmartAssistant: HasProcessedDataCollector {
  var timer: Variable<TimerState> { get set }
  var backgroundScheduler: ConcurrentDispatchQueueScheduler { get set }

  var lastClassification: Variable<ClassifiableData?> { get set }
  func startSmartAssistant(with startTime: StartTime)
}

extension SmartAssistant {
  func startSmartAssistant(with startTime: StartTime = StartTime(time: Date()
    .addingTimeInterval(1).timeIntervalSince1970)) {
    startSmartAssistant(with: startTime)
  }
}
