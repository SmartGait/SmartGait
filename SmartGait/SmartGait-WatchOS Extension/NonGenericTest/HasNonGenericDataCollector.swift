//
//  HasNonGenericDataCollector.swift
//  SmartGait-WatchOS Extension
//
//  Created by Francisco Gonçalves on 16/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

protocol HasNonGenericDataCollector: class {
  var processedDataCollector: NonGenericDataCollector? { get set }

  var frequency: Hz { get set }
  var startTime: StartTime? { get set }

  var startTimerDuration: TimeInterval { get set }
  var isEnabled: Variable<Bool> { get set }
  var hasNewData: Variable<Bool> { get set }
  var lastBatchIndex: Variable<Int?> { get set }
  var processedData: Variable<[RawData]> { get set }
  var lastEntry: Variable<RawData?> { get set }

  var backgroundScheduler: ConcurrentDispatchQueueScheduler { get set }

  var disposeBag: DisposeBag { get set }

  func startCollectingData(at startTime: StartTime)
  func setupBindings()
  func enableDataCollection()
  func resumeDataCollection()
  func pauseDataCollection()
}

extension HasNonGenericDataCollector {
  func startCollectingData(at startTime: StartTime) {
    self.startTime = startTime
    processedDataCollector = NonGenericDataCollector(frequency: frequency, startTime: startTime)
    setupBindings()
    processedDataCollector?.collectData()
  }

  func setupBindings() {
    guard let processedDataCollector = processedDataCollector else {
      return
    }
    processedDataCollector.isEnabled
      .asObservable()
      .observeOn(backgroundScheduler)
      .bind(to: isEnabled)
      .addDisposableTo(disposeBag)

    processedDataCollector.hasNewData
      .asObservable()
      .observeOn(backgroundScheduler)
      .bind(to: hasNewData)
      .addDisposableTo(disposeBag)

    processedDataCollector.lastBatchIndex
      .asObservable()
      .observeOn(backgroundScheduler)
      .bind(to: lastBatchIndex)
      .addDisposableTo(disposeBag)

    processedDataCollector.processedData
      .asObservable()
      .observeOn(backgroundScheduler)
      .bind(to: processedData)
      .addDisposableTo(disposeBag)

    processedDataCollector.lastEntry
      .asObservable()
      .observeOn(backgroundScheduler)
      .bind(to: lastEntry)
      .addDisposableTo(disposeBag)
  }

  func enableDataCollection() {
    processedDataCollector?.isEnabled.value = true
  }

  func resumeDataCollection() {
    processedDataCollector?.isEnabled.value = true
  }

  func pauseDataCollection() {
    processedDataCollector?.isEnabled.value = false
  }
}
