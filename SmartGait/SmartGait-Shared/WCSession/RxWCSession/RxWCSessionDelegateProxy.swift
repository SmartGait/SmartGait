//
//  RxWCSessionDelegateProxy.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 08/02/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Result
import RxCocoa
import RxSwift
import WatchConnectivity

public class RxWCSessionDelegateProxy: DelegateProxy {

  let activationDidCompleteSubject = PublishSubject<Result<WCSessionActivationState, AnyError>>()
  let didBecomeInactiveSubject = PublishSubject<WCSession>()
  let didDeactivateSubject = PublishSubject<WCSession>()
  let didReceiveMessageWithReplyHandlerSubject = PublishSubject<([String : Any], ([String : Any]) -> Void)>()
  let didReceiveDataWithReplyHandlerSubject = PublishSubject<(Data, (Data) -> Void)>()
  let didFinishFileTransfer = PublishSubject<Result<WCSessionFileTransfer, AnyError>>()

  internal func handle(_ session: WCSession,
                       activationDidCompleteWith activationState: WCSessionActivationState,
                       error: Error?) {
    if let error = error {
      activationDidCompleteSubject.on(.next(.failure(AnyError(error))))
    } else {
      activationDidCompleteSubject.on(.next(.success(activationState)))
    }

    self._forwardToDelegate?.session(session, activationDidCompleteWith: activationState, error: error)
  }

  public func session(_ session: WCSession, didReceiveMessage message: [String : Any],
               replyHandler: @escaping ([String : Any]) -> Void) {
    didReceiveMessageWithReplyHandlerSubject.on(.next((message, replyHandler)))
  }
  public func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
    didReceiveDataWithReplyHandlerSubject.on(.next((messageData, replyHandler)))
  }

  public func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
    if let error = error {
      didFinishFileTransfer.on(.next(.failure(AnyError(error))))
    } else {
      didFinishFileTransfer.on(.next(.success(fileTransfer)))
    }
    self._forwardToDelegate?.session(session, didFinish: fileTransfer, error: error)
  }

  deinit {
    activationDidCompleteSubject.on(.completed)
    didBecomeInactiveSubject.on(.completed)
    didDeactivateSubject.on(.completed)
    didReceiveMessageWithReplyHandlerSubject.on(.completed)
    didReceiveDataWithReplyHandlerSubject.on(.completed)
    didFinishFileTransfer.on(.completed)
  }

}

extension RxWCSessionDelegateProxy: DelegateProxyType {
  public static func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
    let session = object as? WCSession
    return session?.delegate
  }

  public class func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
    let session = object as? WCSession
    session?.delegate = delegate as? WCSessionDelegate
  }
}
