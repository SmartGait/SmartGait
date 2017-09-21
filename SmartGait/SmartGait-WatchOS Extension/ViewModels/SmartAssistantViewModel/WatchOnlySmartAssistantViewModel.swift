//
//  WatchOnlySmartAssistantViewController.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 22/04/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreMotion
import Foundation
import RxCocoa
import RxCoreMotion
import RxSwift

class WatchOnlySmartAssistantViewModel: WatchOnlySmartAssistant {
  // MARK: - HasProcessedDataCollector Properties
  var frequency: Hz
  var startTime: StartTime?
  var processedDataCollector: ProcessedDataCollector<ProcessedData>?
  var disposeBag = DisposeBag()

  var startTimerDuration: TimeInterval
  var isEnabled: Variable<Bool> = Variable(false)
  var hasNewData: Variable<Bool>  = Variable(false)
  var lastBatchIndex: Variable<Int?> = Variable(nil)
  var processedData = Variable<[ProcessedData]>([])
  var lastEntry = Variable<ProcessedData?>(nil)

  // MARK: - SmartAssistant Properties
  var backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
  var timer = Variable(TimerState.notStarted)
  var lastClassification = Variable<ClassifiableData?>(nil)


  init(
    startTimerDuration: TimeInterval = 5,
    frequency: Hz
    ) {
    self.startTimerDuration = startTimerDuration
    self.frequency = frequency
  }
}
