//
//  HasCoreMotion.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 20/04/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreMotion
import Foundation
import RxSwift
import RxCocoa
import RxCoreMotion

protocol HasCoreMotionManager {
  var coreMotionManager: CoreMotionManager { get set }
  var accelerationObservable: Observable<CMAcceleration> { get }
  var accelerometerDataObservable: Observable<CMAccelerometerData> { get }
  var rotationRateObservable: Observable<CMRotationRate> { get }
  var deviceMotionObservable: Observable<CMDeviceMotion> { get }
}

extension HasCoreMotionManager {
  var accelerationObservable: Observable<CMAcceleration> { return coreMotionManager.accelerationObservable }
  var accelerometerDataObservable: Observable<CMAccelerometerData> {
    return coreMotionManager.accelerometerDataObservable
  }
  var rotationRateObservable: Observable<CMRotationRate> { return coreMotionManager.rotationRateObservable }
  var deviceMotionObservable: Observable<CMDeviceMotion> { return coreMotionManager.deviceMotionObservable }
}
