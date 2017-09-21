//
//  NonGenericSmartAssistant.swift
//  SmartGait-WatchOS Extension
//
//  Created by Francisco Gonçalves on 16/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation

import Foundation
import RxCocoa
import RxSwift

protocol NonGenericSmartAssistant: HasNonGenericDataCollector {
  var timer: Variable<TimerState> { get set }

  var lastClassification: Variable<ClassifiableData?> { get set }
  func startSmartAssistant(with startTime: StartTime)
}

extension NonGenericSmartAssistant {
  func startSmartAssistant(with startTime: StartTime = StartTime(time: Date()
    .addingTimeInterval(1).timeIntervalSince1970)) {
    startSmartAssistant(with: startTime)
  }
}

