//
//  ActivityMotionManager.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 03/05/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import CoreMotion
import RxSwift
import RxCocoa
import RxCoreMotion

typealias CoreMotionActivityObservableCreator = Observable<MotionActivityManager>
typealias DefaultMotionActivityObservableCreator = (_ motionActivityManager: Observable<MotionActivityManager>)
  -> Observable<CMMotionActivity>

struct CoreMotionActivityManager {

  fileprivate let motionActivityManagerObservable: Observable<MotionActivityManager>

  let motionActivityObservable: Observable<CMMotionActivity>

  init(
    motionActivityManagerObservable: CoreMotionActivityObservableCreator = CoreMotionActivityManager
    .defaultCoreMotionActivityObservableCreator(),
    motionActivityObservable: DefaultMotionActivityObservableCreator = CoreMotionActivityManager
    .defaultMotionActivityObservableCreator()
    ) {

    let motionActivityManagerObservable = motionActivityManagerObservable
    self.motionActivityManagerObservable = motionActivityManagerObservable
    self.motionActivityObservable = motionActivityObservable(motionActivityManagerObservable)
  }
}

extension CoreMotionActivityManager {
  static func defaultCoreMotionActivityObservableCreator() -> CoreMotionActivityObservableCreator {
    return CMMotionActivityManager.rx.manager()
  }

  static func defaultMotionActivityObservableCreator() -> DefaultMotionActivityObservableCreator {
    return { coreMotionActivityManager in
      return coreMotionActivityManager
        .flatMapLatest { manager in
          manager.motionActivity ?? Observable.empty()
        }
        .observeOn(MainScheduler.instance)
        .shareReplayLatestWhileConnected()
    }
  }
}
