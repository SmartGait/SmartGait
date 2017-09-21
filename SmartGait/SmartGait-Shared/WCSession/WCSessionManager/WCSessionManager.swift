//
//  WCSessionManager.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 08/02/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import Result
import RxSwift
import WatchConnectivity

/**
 After setting up the observables don't forget to do session.activate()
*/

class WCSessionManager {
  let session: WCSession
  private static let sharedInstance = try? WCSessionManager()
  internal let disposeBag = DisposeBag()
  // swiftlint:disable weak_delegate
  var delegate: WCSessionDelegate?

  var backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)

  private init() throws {
    guard WCSession.isSupported() else {
      throw "Session not supported"
    }

    session = WCSession.default
    self.delegate = RxWCSessionDelegateProxy.createProxyForObject(self) as? WCSessionDelegate

    guard let delegate = self.delegate else {
      throw "Couldn't create a delegate"
    }

    session.delegate = delegate
    session.activate()

    setupObservables()
  }

  func isReachable() -> Observable<Bool> {
    let activationDidComplete = session.rx
      .activationDidComplete
      .flatMap { _ -> Observable<Bool> in
        .just(self.session.isReachable)
      }

    let isReachable = Observable<Observable<Bool>>
      .of(activationDidComplete, Observable.just(session.isReachable))
      .merge()

    return isReachable
  }

  static func sharedInstanceFunc() throws -> WCSessionManager {
    guard let sharedInstance = WCSessionManager.sharedInstance else {
      return try WCSessionManager()
    }

    return sharedInstance
  }
}
