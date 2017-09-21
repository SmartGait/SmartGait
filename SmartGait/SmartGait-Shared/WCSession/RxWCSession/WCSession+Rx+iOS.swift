//
//  WCSession+Rx+iOS.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 08/02/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import RxSwift
import RxCocoa
import WatchConnectivity

extension Reactive where Base : WCSession {

  @available(iOS 9.3, *)
  public var didBecomeInactive: Observable<WCSession> {
    return delegateProxy.didBecomeInactiveSubject
  }

  @available(iOS 9.3, *)
  public var didDeactivate: Observable<WCSession> {
    return delegateProxy.didDeactivateSubject

  }

  @available(iOS 9.0, *)
  public var watchStateDidChange: Observable<WCSession> {
    return delegate
      .methodInvoked(#selector(WCSessionDelegate.sessionWatchStateDidChange(_:)))
      .map { a in
        return try castOrThrow(WCSession.self, a[0])
    }
  }
}
