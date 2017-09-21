//
//  StepViewModel.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 05/02/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreMotion
import RxCoreMotion
import UIKit

struct StepViewModel: HasCoreMotionManager {
  let identifier: String
  let description: String
  let spokenInstruction: String
  let image: UIImage?
  let until: Observable<Bool>
  var coreMotionManager: CoreMotionManager

  let step: Variable<Step?> = Variable(nil)
  let disposeBag = DisposeBag()

  init(
    identifier: String,
    description: String,
    spokenInstruction: String? = nil,
    image: UIImage? = nil,
    until: Observable<Bool>,
    coreMotionManager: CoreMotionManager = CoreMotionManager()) {
    self.identifier = identifier
    self.description = description
    self.spokenInstruction = spokenInstruction ?? description
    self.image = image
    self.until = until
    self.coreMotionManager = coreMotionManager
  }

  func collect() -> Observable<Step> {
    return collect(until: until)
  }

  func collect(until: Observable<Bool>) -> Observable<Step> {
    return Observable
      .combineLatest(collectAccelerometer(until: until),
                     collectDeviceMotion(until: until)) { (accelerometer, deviceMotion) -> Step in

                      let step = Step(identifier: self.identifier,
                                      accelerometer: accelerometer, deviceMotion: deviceMotion)
                      self.step.value = step
                      return step
      }
      .take(1)
  }
}

extension StepViewModel {
  //measure accelerometer
  func collectAccelerometer(until: Observable<Bool>) -> Observable<AccelerometerResult> {
    let identifier = "accelerometer"
    let startDate = Date()
    var endDate = Date()

    let accelerometerData = Variable<[CMAccelerometerData]>([])

    let collectAccelerometerData = coreMotionManager
      .accelerometerDataObservable
      .do(onNext: { (accData) in
        accelerometerData.value.append(accData)
      })
      .takeUntil(until)

    let mapAccelerometerData: Observable<AccelerometerResult> = until
      .take(1)
      .map { _ in accelerometerData.value }
      .map { $0.map { $0.mapToAccelerometerData() } }
      .map { items in AccelerometerItems(items: items) }
      .map { accelerometerItems in
        endDate = Date()
        return AccelerometerResult(identifier: identifier,
                                   startDate: startDate,
                                   endDate: endDate,
                                   fileURL: nil,
                                   data: accelerometerItems)
    }

    return .zip(collectAccelerometerData, mapAccelerometerData) { $1 }
  }

  //measure deviceMotion
  func collectDeviceMotion(until: Observable<Bool>) -> Observable<DeviceMotionResult> {
    let identifier = "deviceMotion"
    let startDate = Date()

    let deviceMotionData = Variable<[CMDeviceMotion]>([])

    let collectDeviceMotionData = deviceMotionObservable
      .do(onNext: { (dmData) in
        deviceMotionData.value.append(dmData)
      })
      .takeUntil(until)

    let mapDeviceMotionData: Observable<DeviceMotionResult> = until
      .take(1)
      .map { _ in deviceMotionData.value }
      .map { $0.map { $0.mapToDeviceMotionData() } }
      .map { items in DeviceMotionItems(items: items) }
      .map { deviceMotionItems in
        let endDate = Date()
        return DeviceMotionResult(identifier: identifier,
                                  startDate: startDate,
                                  endDate: endDate,
                                  fileURL: nil,
                                  data: deviceMotionItems)
    }

    return .zip(collectDeviceMotionData, mapDeviceMotionData) { $1 }
  }
}
