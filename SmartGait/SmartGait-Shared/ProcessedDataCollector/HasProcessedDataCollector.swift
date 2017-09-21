//
//  HasProcessedDataCollector.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 22/04/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol HasProcessedDataCollector: class {
  associatedtype MData: MotionData
  var processedDataCollector: ProcessedDataCollector<MData>? { get set }

  var frequency: Hz { get set }
  var startTime: StartTime? { get set }

  var startTimerDuration: TimeInterval { get set }
  var isEnabled: Variable<Bool> { get set }
  var hasNewData: Variable<Bool> { get set }
  var lastBatchIndex: Variable<Int?> { get set }
  var processedData: Variable<[MData]> { get set }
  var lastEntry: Variable<MData?> { get set }

  var disposeBag: DisposeBag { get set }

  func startCollectingData(at startTime: StartTime)
  func setupBindings()
  func enableDataCollection()
  func resumeDataCollection()
  func pauseDataCollection()
}

extension HasProcessedDataCollector {
  func startCollectingData(at startTime: StartTime) {
    self.startTime = startTime
    processedDataCollector = ProcessedDataCollector(frequency: frequency, startTime: startTime)
    setupBindings()
    processedDataCollector?.collectData()
  }

  func setupBindings() {
    guard let processedDataCollector = processedDataCollector else {
      return
    }
    processedDataCollector.isEnabled
      .asObservable()
      .bind(to: isEnabled)
      .addDisposableTo(disposeBag)

    processedDataCollector.hasNewData
      .asObservable()
      .bind(to: hasNewData)
      .addDisposableTo(disposeBag)

    processedDataCollector.lastBatchIndex
      .asObservable()
      .bind(to: lastBatchIndex)
      .addDisposableTo(disposeBag)

    processedDataCollector.processedData
      .asObservable()
      .bind(to: processedData)
      .addDisposableTo(disposeBag)

    processedDataCollector.lastEntry
      .asObservable()
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
