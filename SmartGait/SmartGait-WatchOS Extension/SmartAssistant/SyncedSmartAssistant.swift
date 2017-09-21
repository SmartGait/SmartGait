//
//  SyncedSmartAssistant.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 22/04/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol SyncedSmartAssistant: SmartAssistant {
  var receivedSyncMessage: Variable<Bool> { get set }
  var sensitivity: Variable<Float> { get set }
  var processedDataBackgroundScheduler: ConcurrentDispatchQueueScheduler { get set }
}

extension SyncedSmartAssistant {
  fileprivate var sessionManager: WCSessionManager? {
    return try? WCSessionManager.sharedInstanceFunc()
  }

  func startSmartAssistant(with startTime: StartTime) {
    startCollectingData(at: startTime)
    setupSmartAssistant()
  }

  private func send(processedData: MData) {
    let message: [String: Any] = [MData.nextDataElement: processedData.toJSON()]
    let sendAt = Date().timeIntervalSince1970
    log.warning("send at: \(Date().timeIntervalSince1970)")
    self.sessionManager?.session.sendMessage(message, replyHandler: { (message) in
      let receivedAt = Date().timeIntervalSince1970
      let interval = receivedAt - sendAt
      log.error("Interval: \(interval)")
      print("Interval: \(interval)")
      log.info(message)
      processedData.dataClassification = DataClassification(JSON: message)
      self.lastClassification.value = processedData
    })
  }

  private func setupSmartAssistant() {
    guard let sessionManager = sessionManager else {
      return
    }

    let isReachable = sessionManager
      .isReachable()
      .filter { $0 }

    setupStartTime(isReachable: isReachable)
      .do(onNext: { _ in self.enableDataCollection() })
      .subscribe()
      .addDisposableTo(disposeBag)

    //    processedData
    //      .asObservable()
    //      .map { $0.last }
    lastEntry
      .asObservable()
      .observeOn(processedDataBackgroundScheduler)
      .unwrap()
      .do(onNext: send)
      .subscribe()
      .addDisposableTo(disposeBag)

    sensitivity
      .asObservable()
      .skip(1)
      .map { _ in nil }
      .do(onNext: sendUpdateSmartAssistantSensivityMessage)
      .subscribe()
      .addDisposableTo(disposeBag)
  }

  private func setupStartTime(isReachable: Observable<Bool>) -> Observable<Void> {
    isReachable
      .take(1)
      .observeOn(backgroundScheduler)
      .do(onNext: sendStartAssistantMessage)
      .subscribe()
      .addDisposableTo(disposeBag)

    return receivedSyncMessage
      .asObservable()
      .filter { $0 }
      .map { _ in return self.startTime }
      .unwrap()
      .flatMap(startInitialTimer)
      .map(void)
  }

  private func sendStartAssistantMessage(_: Bool? = nil) {
    let startSmartAssistantData = StartSmartAssistant(startTime: startTime, sensitivity: sensitivity.value)

    let message: [String: Any] = [MData.startSmartAssistant: startSmartAssistantData.toJSON()]
    self.sessionManager?.session.sendMessage(message, replyHandler: { (message) in
      log.info(message)
      self.receivedSyncMessage.value = true
    })
  }

  private func sendResumeAssistantMessage(_: Bool? = nil) {
    let message: [String: Any] = [MData.resumeSmartAssistant: ""]
    self.sessionManager?.session.sendMessage(message, replyHandler: { (message) in
      log.info("Start: \(message)")
    })
  }

  private func sendStopAssistantMessage(_: Bool? = nil) {
    let message: [String: Any] = [MData.stopSmartAssistant: ""]
    self.sessionManager?.session.sendMessage(message, replyHandler: { (message) in
      log.info("Stop: \(message)")
    })
  }

  private func sendUpdateSmartAssistantSensivityMessage(_: Bool? = nil) {
    let startSmartAssistantData = StartSmartAssistant(startTime: nil, sensitivity: sensitivity.value)

    let message: [String: Any] = [MData.updateSmartAssistantSensivity: startSmartAssistantData.toJSON()]
    self.sessionManager?.session.sendMessage(message, replyHandler: { (message) in
      log.info("Stop: \(message)")
    })
  }

  private func startInitialTimer(with startTime: StartTime) -> Observable<Int> {
    return Observable<Int>
      .timer(startTime.secondsLeft(), scheduler: MainScheduler.instance)
      .do(onNext: handleTimerStarted)
      .flatMap { (_) -> Observable<Int> in
        .timer(self.startTimerDuration, scheduler:  MainScheduler.instance)
      }
      .do(onNext: handleTimerEnd)
  }

  private func handleTimerStarted(_: Int) {
    timer.value = .started
  }

  private func handleTimerEnd(_: Int) {
    timer.value = .ended
  }

  func resumeDataCollection() {
    sendResumeAssistantMessage()
    processedDataCollector?.isEnabled.value = true
  }

  func pauseDataCollection() {
    sendStopAssistantMessage()
    processedDataCollector?.isEnabled.value = false
  }
}
