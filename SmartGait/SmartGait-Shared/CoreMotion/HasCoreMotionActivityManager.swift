//
//  HasActivityMotionManager.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 03/05/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreMotion
import Foundation
import RxSwift
import RxCocoa
import RxCoreMotion

protocol HasCoreMotionActivityManager {
    var coreMotionActivityManager: CoreMotionActivityManager { get set }
    var motionActivityObservable: Observable<CMMotionActivity> { get }
}

extension HasCoreMotionActivityManager {
    var motionActivityObservable: Observable<CMMotionActivity> {
      return coreMotionActivityManager.motionActivityObservable
  }
}
