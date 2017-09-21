//
//  SmartAssistantViewModel.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 25/01/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreMotion
import RxCoreMotion
import GLKit

class MeasurementsViewModel: NSObject, HasCoreMotionManager {
  internal var coreMotionManager: CoreMotionManager
  internal var running: Variable<Bool>
  internal var reset: Variable<Bool>

  fileprivate var referenceAttitude: CMAttitude?
  fileprivate var measurements: [Measurement]

  internal let viewModels: Variable<[MeasurementViewModel]>
  fileprivate var accelerationViewModel = MeasurementViewModel(name: "Acceleration", x: 0, y: 0, z: 0)
  fileprivate var rotationRateViewModel = MeasurementViewModel(name: "Rotation Rate", x: 0, y: 0, z: 0)
  fileprivate var attitudeViewModel = MeasurementViewModel(name: "DM - Attitude", x: 0, y: 0, z: 0)
  fileprivate var dmRotationRateViewModel = MeasurementViewModel(name: "DM - Rotation Rate", x: 0, y: 0, z: 0)
  fileprivate var userAccelerationViewModel = MeasurementViewModel(name: "DM - User accel", x: 0, y: 0, z: 0)
  fileprivate var gravitationViewModel = MeasurementViewModel(name: "DM - Gravity", x: 0, y: 0, z: 0)
  fileprivate var rotatatedGravitationViewModel = MeasurementViewModel(name: "DM - R Gravity", x: 0, y: 0, z: 0)

  init(
    coreMotionManager: CoreMotionManager = CoreMotionManager(),
    running: Variable<Bool> = Variable(false),
    reset: Variable<Bool> = Variable(false),
    measurements: [Measurement] = [],
    referenceAttitude: CMAttitude? = nil
    ) {

    self.coreMotionManager = coreMotionManager
    self.running = running
    self.reset = reset
    self.measurements = measurements
    self.referenceAttitude = referenceAttitude

    viewModels = Variable([accelerationViewModel, rotationRateViewModel, attitudeViewModel, dmRotationRateViewModel,
                           userAccelerationViewModel, gravitationViewModel, rotatatedGravitationViewModel])
    super.init()

    setupViewModelsBindings(accelerationObservable: accelerationObservable,
                            rotationRateObservable: rotationRateObservable,
                            deviceMotionObservable: deviceMotionObservable)

    setupCollectingMotionData(accelerationObservable: accelerationObservable,
                              rotationRateObservable: rotationRateObservable,
                              deviceMotionObservable: deviceMotionObservable)
  }
}

typealias SetupBindingsToViewModels = MeasurementsViewModel
fileprivate extension SetupBindingsToViewModels {
  fileprivate func setupViewModelsBindings(accelerationObservable: Observable<CMAcceleration>,
                                           rotationRateObservable: Observable<CMRotationRate>,
                                           deviceMotionObservable: Observable<CMDeviceMotion>) {
    setupAcceleration(accelerationObservable: accelerationObservable)
    setupRotationRate(rotationRateObservable: rotationRateObservable)
    setupDeviceMotion(deviceMotionObservable: deviceMotionObservable)
  }

  private func setupAcceleration(accelerationObservable: Observable<CMAcceleration>) {
    accelerationObservable
      .map(self.accelerationViewModel.updateValues)
      .subscribe()
      .addDisposableTo(rx_disposeBag)
  }

  private func setupRotationRate(rotationRateObservable: Observable<CMRotationRate>) {
    rotationRateObservable
      .map(self.rotationRateViewModel.updateValues)
      .subscribe()
      .addDisposableTo(rx_disposeBag)
  }

  private func setupDeviceMotion(deviceMotionObservable: Observable<CMDeviceMotion>) {
    deviceMotionObservable
      .map {
        if self.reset.value {
          self.referenceAttitude = $0.attitude.copy() as? CMAttitude
          self.reset.value = false
        }

        if let referenceAttitude = self.referenceAttitude {
          $0.attitude.multiply(byInverseOf: referenceAttitude)

          let gravityInAtomicReference = $0.gravity.acceleration(inReferenceFrame: referenceAttitude)

          self.rotatatedGravitationViewModel.updateValues(threeAxis: gravityInAtomicReference)
        }

        self.attitudeViewModel.updateValues(fourAxis: $0.attitude.quaternion)
        self.dmRotationRateViewModel.updateValues(threeAxis: $0.rotationRate)
        self.userAccelerationViewModel.updateValues(threeAxis: $0.userAcceleration)
        self.gravitationViewModel.updateValues(threeAxis: $0.gravity)
      }
      .subscribe()
      .addDisposableTo(rx_disposeBag)
  }
}

typealias SetupCollectingMotionData = MeasurementsViewModel
fileprivate extension SetupCollectingMotionData {
  fileprivate func setupCollectingMotionData(accelerationObservable: Observable<CMAcceleration>,
                                             rotationRateObservable: Observable<CMRotationRate>,
                                             deviceMotionObservable: Observable<CMDeviceMotion>) {
    running.asObservable()
      .filter { $0 }
      .flatMap(createMeasurement)
      .do(onNext: appendToMeasures)
      .takeWhile { _ in self.running.value }
      .subscribe(saveToCoreData)
      .addDisposableTo(rx_disposeBag)
  }

  private func createMeasurement(_: Bool) -> Observable<Measurement> {
    return Observable
      .combineLatest(accelerationObservable,
                     rotationRateObservable,
                     deviceMotionObservable) { (acceleration, rotationRate, deviceMotion) -> Measurement in
                      return Measurement(timestamp: NSDate(),
                                         acceleration: acceleration,
                                         rotationRate: rotationRate,
                                         attitude: deviceMotion.attitude,
                                         dmRotationRate:deviceMotion.rotationRate,
                                         userAcceleration: deviceMotion.userAcceleration,
                                         gravity: deviceMotion.gravity)

    }
  }

  private func appendToMeasures(measurement: Measurement) {
    self.measurements.append(measurement)
  }

  private func saveToCoreData<E>(_: RxSwift.Event<E>) {
    let context = CoreDataManager.sharedInstance.backgroundContext

    _ = self.measurements.flatMap { $0.getCoreDataObject(for: context) }

    CoreDataManager.sharedInstance.save(context: context)
  }
}
