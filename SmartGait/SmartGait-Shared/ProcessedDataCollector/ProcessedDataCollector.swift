//
//  ProcessedDataCollector.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 21/04/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreMotion
import RxCoreMotion

typealias CoreMotionManagerCreator = (_ frequency: Hz) -> CoreMotionManager
typealias CoreMotionActivityManagerCreator = CoreMotionActivityManager

class ProcessedDataCollector<MData: MotionData>: HasCoreMotionManager, HasCoreMotionActivityManager {

  // MARK: HasCoreMotionManager Properties
  internal var coreMotionManager: CoreMotionManager

  // MARK: HasCoreMotionManager Properties
  internal var coreMotionActivityManager: CoreMotionActivityManager

  fileprivate var motionDataBuffer: TimestampBuffer<CMDeviceMotion>
  fileprivate var motionActivityBuffer: SynchronizedBuffer<CMMotionActivity>
  fileprivate let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
  fileprivate let disposeBag = DisposeBag()

  let isEnabled: Variable<Bool>
  let hasNewData: Variable<Bool>
  let lastBatchIndex: Variable<Int?>
  let processedData = Variable<[MData]>([])
  let lastEntry = Variable<MData?>(nil)

  init(
    frequency: Hz,
    startTime: StartTime,
    isEnabled: Variable<Bool> = Variable(false),
    hasNewData: Variable<Bool> = Variable(false),
    lastBatchIndex: Variable<Int?> = Variable(nil),
    coreMotionManager: CoreMotionManagerCreator = ProcessedDataCollector.defaultCoreMotionManager(),
    coreMotionActivityManager: CoreMotionActivityManagerCreator = ProcessedDataCollector
    .defaultCoreMotionActivityManager()
    ) {

    self.coreMotionManager = coreMotionManager(frequency)
    self.motionDataBuffer = TimestampBuffer(startingTime: startTime.time)
    self.motionActivityBuffer = SynchronizedBuffer()
    self.isEnabled = isEnabled
    self.hasNewData = hasNewData
    self.lastBatchIndex = lastBatchIndex
    self.coreMotionActivityManager = coreMotionActivityManager
  }

}

extension ProcessedDataCollector {
  func collectData() {
    deviceMotionObservable
      .observeOn(backgroundScheduler)
      .filter { _ in self.isEnabled.value }
      .do(onNext: appendMotionDataToBuffer)
      .observeOn(backgroundScheduler)
      .subscribe()
      .addDisposableTo(disposeBag)

    motionActivityObservable
      .observeOn(backgroundScheduler)
      .filter { _ in self.isEnabled.value }
      .do(onNext: appendMotionActivityToBuffer)
      .subscribe()
      .addDisposableTo(disposeBag)
  }

  private func appendMotionDataToBuffer(data: CMDeviceMotion) {
    guard !motionDataBuffer.isFull() else {
      print("MOTION DATA SIZE: \(motionDataBuffer.data.count)")
      handleFullBuffer()
      return
    }

    motionDataBuffer.append(data: data)
  }

  private func appendMotionActivityToBuffer(data: CMMotionActivity) {
    motionActivityBuffer.append(data: data)
  }

  private func handleFullBuffer() {
    do {
      let motionData = try motionDataBuffer.getDataCopy()
      motionDataBuffer.reset()

      let motionActivity = try motionActivityBuffer.getDataCopy()
      motionActivityBuffer.reset()

      let identifier = processedData.value.count
      print(identifier)

      let last = processedData.value.last

      //swiftlint:disable force_cast
      let newEntry = try MData
        .handle(motionData: motionData, motionActivity: motionActivity, with: identifier, last: last) as! MData

      processedData
        .value
        .append(newEntry)

      lastEntry.value = newEntry

      updateSideEffects(with: identifier)
//      try DispatchQueue.main.sync {
//      }
    } catch let error {
      print(error)
    }
  }

  func updateSideEffects(with identifier: Int) {
    hasNewData.value = true
    lastBatchIndex.value = identifier
//    print(identifier)
  }
}

extension ProcessedDataCollector {
  static func defaultCoreMotionManager() -> CoreMotionManagerCreator {
    return { frequency in
      return CoreMotionManager(frequency: frequency)
    }
  }

  static func defaultCoreMotionActivityManager() -> CoreMotionActivityManagerCreator {
    return CoreMotionActivityManager()
  }

  static func defaultBuffer() -> CoreMotionManagerCreator {
    return { frequency in
      return CoreMotionManager(frequency: frequency)
    }
  }
}
