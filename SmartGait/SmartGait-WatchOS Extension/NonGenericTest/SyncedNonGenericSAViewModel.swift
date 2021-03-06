//
//  SyncedNonGenericSAViewModel.swift
//  SmartGait-WatchOS Extension
//
//  Created by Francisco Gonçalves on 16/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreMotion
import Foundation
import RxCocoa
import RxCoreMotion
import RxSwift

class SyncedNonGenericSAViewModel: NonGenericSyncedSmartAssistant {
  var statistics: SyncStatistics = SyncStatistics()

  // MARK: - HasProcessedDataCollector Properties
  var frequency: Hz
  var startTime: StartTime?
  var processedDataCollector: NonGenericDataCollector?
  var disposeBag = DisposeBag()

  var startTimerDuration: TimeInterval
  var isEnabled: Variable<Bool> = Variable(false)
  var hasNewData: Variable<Bool> = Variable(false)
  var lastBatchIndex: Variable<Int?> = Variable(nil)
  var processedData = Variable<[RawData]>([])
  var lastEntry = Variable<RawData?>(nil)

  // MARK: - Synced SmartAssistant Properties
  var backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
  var processedDataBackgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
  var receivedSyncMessage = Variable(false)
  var timer = Variable(TimerState.notStarted)
  var lastClassification = Variable<ClassifiableData?>(nil)

  var sensitivity: Variable<Float> = Variable(0.5)

  init(
    startTimerDuration: TimeInterval = 5,
    frequency: Hz
    ) {
    self.startTimerDuration = startTimerDuration
    self.frequency = frequency
  }
}
