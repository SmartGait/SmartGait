//
//  iPhoneOnlySmartAssistantViewModel.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 24/04/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreMotion
import RxCoreMotion

// swiftlint:disable type_name
class iPhoneOnlySmartAssistantViewModel: iPhoneOnlySmartAssistant {
  // MARK: - HasProcessedDataCollector properties
  var frequency: Hz
  var startTime: StartTime?

  var disposeBag: DisposeBag = DisposeBag()
  internal var processedDataCollector: ProcessedDataCollector<ProcessedData>?

  var startTimerDuration: TimeInterval
  var isEnabled: Variable<Bool> = Variable(false)
  var hasNewData: Variable<Bool>  = Variable(false)
  var lastBatchIndex: Variable<Int?> = Variable(nil)
  var processedData = Variable<[ProcessedData]>([])
  var lastEntry = Variable<ProcessedData?>(nil)

  // MARK: - SmartAssistant properties
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
