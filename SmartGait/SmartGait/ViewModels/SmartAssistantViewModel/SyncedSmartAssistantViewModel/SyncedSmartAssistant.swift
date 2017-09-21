//
//  SyncedSmartAssistant.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 24/04/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

fileprivate enum ConsumerKey: String {
  case consumed
}

protocol SyncedSmartAssistant: SmartAssistant {
  associatedtype CTask: GenericClassificationTaskModel

  var watchOSLastConsumedData: Variable<MData?> { get set }
  var iOSLastConsumedData: Variable<MData?> { get set }
  var newDataArrived: Variable<Bool> { get set }
  var iOSConsumed: [Int: String] { get set }
  var watchOSConsumed: [Int: String] { get set }
  var classificationOptions: Variable<[ClassifyingOption]> { get set }

  var classificationTask: ClassificationTask<MData, CTask>? { get set }

  var processedDataBackgroundScheduler: ConcurrentDispatchQueueScheduler { get set }
  var mergeDataBackgroundScheduler: ConcurrentDispatchQueueScheduler { get set }
  var serialScheduler: SerialDispatchQueueScheduler { get set }

  var sensitivity: Float { get set }

  func fetchClassificationOptions()
}

extension SyncedSmartAssistant {
  func startSmartAssistant(with startTime: StartTime) {
    setupClassificationTask()
    startCollectingData(at: startTime)
    setupSmartAssistant(with: startTime)
    fetchClassificationOptions()
  }

  private func setupClassificationTask() {
    classificationTask = ClassificationTask()
  }

  private func setupSmartAssistant(with startTime: StartTime) {
    startInitialTimer(with: startTime)
      .map(void)
      .do(onNext: { _ in self.enableDataCollection() }) //FIXME: Update when SE-0110 is rollbacked
      .subscribe()
      .addDisposableTo(disposeBag)

    //    processedData
    //      .asObservable()
    //      .map { $0.last }
    lastEntry
      .asObservable()
      .observeOn(mergeDataBackgroundScheduler)
      //      .observeOn(MainScheduler.instance)
      .unwrap()
      .filter { self.iOSDataNotConsumed(identifier: $0.identifier) }
      .do(onNext: {
        self.consumeIOSData(identifier: $0.identifier)
      })
      .bind(to: iOSLastConsumedData)
      .addDisposableTo(disposeBag)
  }

  private func startInitialTimer(with startTime: StartTime) -> Observable<Int> {
    return Observable<Int>
      .timer(startTime.secondsLeft(), scheduler: MainScheduler.instance)
      .do(onNext: handleTimerStarted)
      //      .flatMap { (_) -> Observable<Int> in
      //        .timer(self.startTimerDuration, scheduler:  MainScheduler.instance)
      //      }
      .do(onNext: handleTimerEnd)
  }

  private func handleTimerStarted(_: Int) {
    timer.value = .started
  }

  private func handleTimerEnd(_: Int) {
    timer.value = .ended
  }
}

extension SyncedSmartAssistant {
  func handle(processedData: MData, replyHandler: @escaping (([String : Any]) -> Void)) {
    guard isEnabled.value else {
      replyHandler(["error": "Not enabled"])
      return
    }

    guard let value = lastBatchIndex.value, processedData.identifier >= value else {
      print("late: \(processedData.identifier); \(lastBatchIndex.value)")
      replyHandler(["error": "Couldn't reply - not synced"])
      return
    }

    if processedData.identifier > value {
      print("early: \(processedData.identifier); \(value)")
    }
//    DispatchQueue.main.async {
//      self.newDataArrived.value = true
//      self.watchOSLastConsumedData.value = processedData
//      self.mergeData(replyHandler: replyHandler)
//    }

    print("ALL GOOD!")

    Observable.just(1)
      .do(onNext: { _ in
        self.newDataArrived.value = true
        self.watchOSLastConsumedData.value = processedData
        self.mergeData(replyHandler: replyHandler)
      })
      .subscribeOn(mergeDataBackgroundScheduler)
      .subscribe()
      .addDisposableTo(disposeBag)
//    Observable.just {
//    }
//    .subscribeOn(mergeDataBackgroundScheduler)
//    .subscribe()
//    .addDisposableTo(disposeBag)
  }

  func mergeData(replyHandler: (([String : Any]) -> Void)? = nil) {
    newDataArrived.value = false
    hasNewData.value = false
    var replied = false

    let watchOSProcessedDataFiltered = watchOSLastConsumedData
      .asObservable()
      .observeOn(mergeDataBackgroundScheduler)
      .unwrap()
      .filter { self.watchOSDataNotConsumed(identifier: $0.identifier) }
      .do(onNext: {
        self.consumewatchOSData(identifier: $0.identifier)
      })

    Observable
      .zip(iOSLastConsumedData.asObservable().observeOn(mergeDataBackgroundScheduler).unwrap(),
           watchOSProcessedDataFiltered, resultSelector: mergeData)
      .observeOn(mergeDataBackgroundScheduler)
      .takeUntil(newWatchOSDataArrived().observeOn(mergeDataBackgroundScheduler))
      .takeUntil(newIOSDataArrived().observeOn(mergeDataBackgroundScheduler))
      .unwrap()
      //      .observeOn(serialScheduler)
      .observeOn(mergeDataBackgroundScheduler)
      .map {
        self.classify(mergedData: $0, withOptions: self.classificationOptions.value, sensitivity: self.sensitivity)
      }
      .unwrap()
      //      .observeOn(MainScheduler.instance)
      .do(onNext: {
        replied = true
        guard let json = $0.dataClassification?.toJSON() else {
          replyHandler?(["error": "Couldn't reply"])
          return
        }
        print("RePLYING with \(json)")
        replyHandler?(json)
      }, onCompleted: {
        if !replied {
          replyHandler?(["error": "Couldn't reply"])
        }
      })
      .take(1)
      .debug()
      .bind(to: lastClassification)
      .addDisposableTo(disposeBag)
  }

  func classify<MD: MotionData>(
    mergedData: MergedData<MD>,
    withOptions options: [ClassifyingOption],
    sensitivity: Float
    ) -> ClassifiableData? {
    var mergedData = mergedData

    return mergedData.classify(withOptions: options, sensitivity: sensitivity)
  }

  func newWatchOSDataArrived() -> Observable<Bool> {
    return newDataArrived.asObservable().filter { $0 }
  }

  func newIOSDataArrived() -> Observable<Bool> {
    return hasNewData.asObservable().filter { $0 }
  }

  func mergeData(iOSData: MData, watchOSData: MData) -> MergedData<MData>? {
    guard iOSData.identifier == watchOSData.identifier else {
      return nil
    }

    debugSync(iOSData: iOSData, watchOSData: watchOSData)
    return MergedData(iOSData: iOSData, watchOSData: watchOSData)
  }
}

extension SyncedSmartAssistant {
  fileprivate func iOSDataNotConsumed(identifier: Int) -> Bool {
    return iOSConsumed.index(forKey: identifier) == nil
  }

  fileprivate func consumeIOSData(identifier: Int) {
    iOSConsumed.updateValue(ConsumerKey.consumed.rawValue, forKey: identifier)
  }

  fileprivate func watchOSDataNotConsumed(identifier: Int) -> Bool {
    return watchOSConsumed.index(forKey: identifier) == nil
  }

  fileprivate func consumewatchOSData(identifier: Int) {
    watchOSConsumed.updateValue(ConsumerKey.consumed.rawValue, forKey: identifier)
  }
}

// MARK: - Debug
extension SyncedSmartAssistant {
  fileprivate func debugSync(iOSData: MData, watchOSData: MData) {
    printDescription(tag: "Last", processedData: iOSData)
    printDescription(tag: "Arrived", processedData: watchOSData)
    print("Time diff initial: \(iOSData.initialTimestamp - watchOSData.initialTimestamp)",
      "final: \(iOSData.finalTimestamp - watchOSData.finalTimestamp)")
  }

  fileprivate func printDescription(tag: String, processedData: MData?) {
    guard let processedData = processedData else {
      return
    }
    print("\(tag): \(processedData.identifier) initialTimestamp: \(processedData.initialTimestamp);",
      "finalTimestamp: \(processedData.finalTimestamp);",
      "diff: \(processedData.finalTimestamp-processedData.initialTimestamp)",
      "samples used: \(processedData.samplesUsed)")
  }
}
