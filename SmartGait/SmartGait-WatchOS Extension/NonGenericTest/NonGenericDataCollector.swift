//
//  NonGenericDataCollector.swift
//  SmartGait-WatchOS Extension
//
//  Created by Francisco Gonçalves on 16/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreMotion
import RxCoreMotion

class NonGenericDataCollector: HasCoreMotionManager, HasCoreMotionActivityManager {

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
  let processedData = Variable<[RawData]>([])
  let lastEntry = Variable<RawData?>(nil)

  init(
    frequency: Hz,
    startTime: StartTime,
    isEnabled: Variable<Bool> = Variable(false),
    hasNewData: Variable<Bool> = Variable(false),
    lastBatchIndex: Variable<Int?> = Variable(nil),
    coreMotionManager: CoreMotionManagerCreator = NonGenericDataCollector.defaultCoreMotionManager(),
    coreMotionActivityManager: CoreMotionActivityManagerCreator = NonGenericDataCollector
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

extension NonGenericDataCollector {
  func collectData() {
    deviceMotionObservable
      .observeOn(backgroundScheduler)
      .filter { _ in self.isEnabled.value }
      .do(onNext: appendMotionDataToBuffer)
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

      let motionActivity = [CMMotionActivity]()
//        try motionActivityBuffer.getData()
//      motionActivityBuffer.reset()

      let identifier = processedData.value.count

      let last = processedData.value.last

      try DispatchQueue.main.sync {
        //swiftlint:disable force_cast
        let newEntry = try RawData
          .handle(motionData: motionData, motionActivity: motionActivity, with: identifier, last: last) as! RawData

        processedData
          .value
          .append(newEntry)

        lastEntry.value = newEntry

        updateSideEffects(with: identifier)
      }
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

extension NonGenericDataCollector {
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
