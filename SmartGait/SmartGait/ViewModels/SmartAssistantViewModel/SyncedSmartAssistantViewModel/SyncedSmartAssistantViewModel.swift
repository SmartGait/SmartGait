//
//  SmartAssistantViewModel.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 22/04/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import RxSwift
import RxCocoa
import CoreMotion
import RxCoreMotion

// swiftlint:disable type_name
typealias Hz = Int
typealias ClassifyingOptionViewModelsConstructor = Variable<[ClassifyingOptionViewModel]>

class SyncedSmartAssistantViewModel<MD: MotionData, CT: GenericClassificationTaskModel>: SyncedSmartAssistant {

  // MARK: - HasProcessedDataCollector properties
  var frequency: Hz
  var startTime: StartTime?

  var disposeBag = DisposeBag()
  internal var processedDataCollector: ProcessedDataCollector<MD>?

  var startTimerDuration: TimeInterval
  var isEnabled: Variable<Bool> = Variable(false)
  var hasNewData: Variable<Bool>  = Variable(false)
  var lastBatchIndex: Variable<Int?> = Variable(nil)
  var processedData = Variable<[MD]>([])
  var lastEntry = Variable<MD?>(nil)

  // MARK: - SmartAssistant properties
  var backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
  var timer = Variable(TimerState.notStarted)
  var lastClassification = Variable<ClassifiableData?>(nil)

  // MARK: - SyncedSmartAssistant properties
  var watchOSLastConsumedData = Variable<MD?>(nil)
  var iOSLastConsumedData = Variable<MD?>(nil)
  var newDataArrived = Variable<Bool>(false)
  var iOSConsumed: [Int: String] = [:]
  var watchOSConsumed: [Int: String] = [:]
  var classificationOptions = Variable<[ClassifyingOption]>([])
  var classificationTask: ClassificationTask<MD, CT>?
  var sensitivity: Float = 0.5

  // MARK: - Self properties
  var classifyingOptionViewModels: Variable<[ClassifyingOptionViewModel]>
  var classificationsBuffer: TimeLimitBuffer<ClassifiableData> = TimeLimitBuffer()

  var processedDataBackgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
  var mergeDataBackgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
  var serialScheduler = SerialDispatchQueueScheduler(internalSerialQueueName: "Classification" )

  var firstClassification: Observable<Void>

  init(
    startTimerDuration: TimeInterval = 5,
    frequency: Hz,
    classifyingOptionViewModels: ClassifyingOptionViewModelsConstructor = SyncedSmartAssistantViewModel
    .defaultClassifyingOptionViewModels()
    ) {
    self.startTimerDuration = startTimerDuration
    self.frequency = frequency
    self.classifyingOptionViewModels = classifyingOptionViewModels

    firstClassification = lastClassification
      .asObservable()
      .unwrap()
      .map(void)
      .take(1)

    lastClassification
      .asObservable()
      .unwrap()
      .do(onNext: appendToBuffer)
      .subscribe()
      .addDisposableTo(disposeBag)
  }

  func fetchClassificationOptions() {
    classifyingOptionViewModels
      .asObservable()
      .map { (viewModels) -> [ClassifyingOption] in
        return viewModels.flatMap { $0.selected ? ClassifyingOption(rawValue: $0.title) : nil }
      }
      .debug()
      .observeOn(backgroundScheduler)
      .bind(to: classificationOptions)
      .addDisposableTo(disposeBag)
  }
}

extension SyncedSmartAssistantViewModel {
  func resume() {
    isEnabled.value = true
  }

  func stop() {
    isEnabled.value = false
    do {
      try updateEndDate()
    } catch let error {
      print(error)
    }
  }
}

extension SyncedSmartAssistantViewModel {
  static func defaultClassifyingOptionViewModels() -> ClassifyingOptionViewModelsConstructor {

    let enabledOptions = [true, true, true, true, true, true, true, false]

    //FIXME: Update when SE-0110 is rollbacked
    let allOptions = zip(ClassifyingOption.allOptions(forType: MData.self), enabledOptions)
      .map { ClassifyingOptionViewModel(title: $0.0.rawValue, selected: $0.1) }

    return Variable(allOptions)
  }
}

extension SyncedSmartAssistantViewModel {

  func appendToBuffer(data: ClassifiableData) {
    guard !classificationsBuffer.isFull() else {
//      print("full buffer")
      DispatchQueue.global().async {
        self.handleFullBuffer()
      }
      return
    }
//    print("not full buffer")
    classificationsBuffer.append(data: data)
  }

  private var context: NSManagedObjectContext? {
    return CoreDataManager.sharedInstance.backgroundContext
  }

  private func handleFullBuffer() {
    do {
      let data = try classificationsBuffer.getDataCopy()
      classificationsBuffer.reset()
      guard data.count > 0 else {
        return
      }
      try saveToCoreData(data: data)
    } catch let error {
      print(error)
    }
  }

  private func saveToCoreData(data: [ClassifiableData]) throws {
    guard let context = context else {
      throw "Context unavailable"
    }

    classificationTask?.mergedData = data
      .flatMap { $0 as? MergedData }

    try classificationTask?.updateMergedData(for: context)
  }

  fileprivate func updateEndDate() throws {
    guard let context = context else {
      throw "Context unavailable"
    }

    try classificationTask?.updateEndDate(for: context)
  }
}
