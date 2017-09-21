//
//  WcSessionManager+iOS.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 11/02/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import Result
import RxSwift
import WatchConnectivity

extension WCSessionManager {
  internal func setupObservables() {
    setupDidDeactivate()
    setupDidReceiveMessageWithReplyHandler()
    setupDidReceiveFile()
    session.activate()
  }

  private func setupDidDeactivate() {
    session.rx
      .didDeactivate
      .do(onNext: { (session) in
        session.activate()
      })
      .subscribe()
      .addDisposableTo(disposeBag)
  }

  private func setupDidReceiveMessageWithReplyHandler() {
    var sessionData: WCSessionData?

    session.rx
      .didReceiveMessageWithReplyHandler
      .observeOn(MainScheduler.instance)
      .do(onNext: { messageHandler in
        let (message, replyHandler) = messageHandler //FIXME: Update when SE-0110 is rollbacked
        guard let key = message.first?.key else {
          return
        }
        print(key)
        do {
          sessionData = WCSessionData(rawValue: key)
          if let value = message.first?.value as? [String: Any] {
            try sessionData?.handle(message: value, replyHandler: replyHandler)
//          } else if let value = message.first?.value as? String {
//            try sessionData?.handle(message: value, replyHandler: replyHandler)
          } else {
            throw "Couldn't cast raw data"
          }
        } catch let error {
          print(error)
          replyHandler(["error": error])
        }
      })
      .subscribe()
      .addDisposableTo(disposeBag)
  }

  private func setupDidReceiveFile() {
    var sessionData: WCSessionData?

    session.rx
      .didReceiveFile
      .observeOn(MainScheduler.instance)
      .do(onNext: { (sessionFile) in
        let metadata = sessionFile.metadata

        guard let key = metadata?.first?.key else {
          log.error("Key not provided")
          return
        }

        do {
          sessionData = WCSessionData(rawValue: key)
          try sessionData?.handle(file: sessionFile.fileURL)
        } catch let error {
          log.error(error)
        }

      })
      .subscribe()
      .addDisposableTo(disposeBag)
  }
}
