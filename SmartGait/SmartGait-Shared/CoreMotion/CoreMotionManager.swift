//
//  CoreMotionManager.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 20/04/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import CoreMotion
import RxSwift
import RxCocoa
import RxCoreMotion

typealias CoreMotionObservableCreator = (_ frequency: Hz) -> Observable<MotionManager>
typealias AccelerationObserverCreator = (_ coreMotionManager: Observable<MotionManager>, _ backgroundScheduler: ConcurrentDispatchQueueScheduler) -> Observable<CMAcceleration>
typealias AccelerometerDataObserverCreator = (_ coreMotionManager: Observable<MotionManager>, _ backgroundScheduler: ConcurrentDispatchQueueScheduler)
  -> Observable<CMAccelerometerData>
typealias RotationRateObserverCreator = (_ coreMotionManager: Observable<MotionManager>, _ backgroundScheduler: ConcurrentDispatchQueueScheduler) -> Observable<CMRotationRate>
typealias DeviceMotionObserverCreator = (_ coreMotionManager: Observable<MotionManager>, _ backgroundScheduler: ConcurrentDispatchQueueScheduler) -> Observable<CMDeviceMotion>

struct CoreMotionManager {

  fileprivate let motionManagerObservable: Observable<MotionManager>

  let accelerationObservable: Observable<CMAcceleration>
  let accelerometerDataObservable: Observable<CMAccelerometerData>
  let rotationRateObservable: Observable<CMRotationRate>
  let deviceMotionObservable: Observable<CMDeviceMotion>

 let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)

  init(
    frequency: Hz = 100,
    motionManagerObservable: CoreMotionObservableCreator = CoreMotionManager.defaultCoreMotionObservableCreator(),
    accelerationObservable: AccelerationObserverCreator = CoreMotionManager.defaultAccelerationObservableCreator(),
    accelerometerDataObservable: AccelerometerDataObserverCreator = CoreMotionManager
    .defaultAccelerometerDataObservableCreator(),
    rotationRateObservable: RotationRateObserverCreator = CoreMotionManager.defaultRotationRateObservableCreator(),
    deviceMotionObservable: DeviceMotionObserverCreator = CoreMotionManager.defaultDeviceMotionObservableCreator()
    ) {

    let motionManagerObservable = motionManagerObservable(frequency)
    self.motionManagerObservable = motionManagerObservable
    self.accelerationObservable = accelerationObservable(motionManagerObservable, backgroundScheduler)
    self.accelerometerDataObservable = accelerometerDataObservable(motionManagerObservable, backgroundScheduler)
    self.rotationRateObservable = rotationRateObservable(motionManagerObservable, backgroundScheduler)
    self.deviceMotionObservable = deviceMotionObservable(motionManagerObservable, backgroundScheduler)
  }
}

extension CoreMotionManager {
  static func defaultCoreMotionObservableCreator() -> CoreMotionObservableCreator {
    return { frequency in
      let rate = 1.0 / Double(frequency)
      return CMMotionManager.rx.manager {
        let motionManager = CMMotionManager()
        motionManager.deviceMotionUpdateInterval = rate
        motionManager.gyroUpdateInterval = rate
        motionManager.accelerometerUpdateInterval = rate
        motionManager.magnetometerUpdateInterval = rate
        return motionManager
      }
    }
  }

  static func defaultAccelerationObservableCreator() -> AccelerationObserverCreator {
    return { coreMotionManager, backgroundScheduler in
      return coreMotionManager
        .flatMapLatest { manager in
          manager.acceleration ?? Observable.empty()
        }
        .observeOn(backgroundScheduler)
        .shareReplayLatestWhileConnected()
    }
  }

  static func defaultAccelerometerDataObservableCreator() -> AccelerometerDataObserverCreator {
    return { coreMotionManager, backgroundScheduler in
      return coreMotionManager
        .flatMapLatest { manager in
          manager.accelerometerData ?? Observable.empty()
        }
        .observeOn(backgroundScheduler)
        .shareReplayLatestWhileConnected()
    }
  }

  static func defaultRotationRateObservableCreator() -> RotationRateObserverCreator {
    return { coreMotionManager, backgroundScheduler in
      return coreMotionManager
        .flatMapLatest { manager in
          manager.rotationRate ?? Observable.empty()
        }
        .observeOn(backgroundScheduler)
        .shareReplayLatestWhileConnected()
    }
  }

  static func defaultDeviceMotionObservableCreator() -> DeviceMotionObserverCreator {
    return { coreMotionManager, backgroundScheduler in
      return coreMotionManager
        .flatMapLatest { manager in
          manager.deviceMotion ?? Observable.empty()
        }
        .observeOn(backgroundScheduler)
        .shareReplayLatestWhileConnected()
    }
  }
}
