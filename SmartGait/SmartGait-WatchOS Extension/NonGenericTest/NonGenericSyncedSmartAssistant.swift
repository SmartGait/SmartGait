//
//  NonGenericSyncedSmartAssistant.swift
//  SmartGait-WatchOS Extension
//
//  Created by Francisco Gonçalves on 16/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class SyncStatistics {
  var packetsSent = 0
  var packetsNonSynced = 0
  var packetsSynced = 0
  var intervals = [Double]()

  func description() -> String {
    return "Packets Sent: \(packetsSent) with \(packetsNonSynced) failures and \(packetsSynced) successes. Mean interval: \(intervals.avg())"
  }
}


protocol NonGenericSyncedSmartAssistant: NonGenericSmartAssistant {
  var receivedSyncMessage: Variable<Bool> { get set }
  var sensitivity: Variable<Float> { get set }
  var processedDataBackgroundScheduler: ConcurrentDispatchQueueScheduler { get set }
  var statistics: SyncStatistics { get set }
}

extension NonGenericSyncedSmartAssistant {
  fileprivate var sessionManager: WCSessionManager? {
    return try? WCSessionManager.sharedInstanceFunc()
  }

  func startSmartAssistant(with startTime: StartTime) {
    startCollectingData(at: startTime)
    setupSmartAssistant()
  }

  private func send(processedData: RawData) {
    let message: [String: Any] = [RawData.nextDataElement: processedData.toJSON()]
    let sentAt = Date().timeIntervalSince1970
    statistics.packetsSent += 1
    log.warning("send at: \(sentAt)")
    self.sessionManager?.session.sendMessage(message, replyHandler: { (message) in
      let receivedAt = Date().timeIntervalSince1970
      let interval = receivedAt - sentAt

      if(message["error"] == nil) {
        log.error("Interval: \(interval)")
        self.statistics.packetsSynced += 1
        self.statistics.intervals.append(interval)
      } else {
        self.statistics.packetsNonSynced += 1
      }

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
      .observeOn(backgroundScheduler)
      .unwrap()
      .do(onNext: { self.send(processedData: $0) })
//      .do(onNext: send)
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
      .observeOn(backgroundScheduler)
      .filter { $0 }
      .map { _ in return self.startTime }
      .unwrap()
      .flatMap(startInitialTimer)
      .map(void)
  }

  private func sendStartAssistantMessage(_: Bool? = nil) {
    let startSmartAssistantData = StartSmartAssistant(startTime: startTime, sensitivity: sensitivity.value)

    let message: [String: Any] = [RawData.startSmartAssistant: startSmartAssistantData.toJSON()]
    self.receivedSyncMessage.value = true
    self.sessionManager?.session.sendMessage(message, replyHandler: { (message) in
      log.info(message)
    })
  }

  private func sendResumeAssistantMessage(_: Bool? = nil) {
    let message: [String: Any] = [RawData.resumeSmartAssistant: ["": ""]]
    self.sessionManager?.session.sendMessage(message, replyHandler: { (message) in
      log.info("Start: \(message)")
    })
  }

  private func sendStopAssistantMessage(_: Bool? = nil, statistics: SyncStatistics? = nil) {
    let message: [String: Any] = [RawData.stopSmartAssistant: ["stats": statistics?.description()]]
    self.sessionManager?.session.sendMessage(message, replyHandler: { (message) in
      log.info("Stop: \(message)")
    })
  }

  private func sendUpdateSmartAssistantSensivityMessage(_: Bool? = nil) {
    let startSmartAssistantData = StartSmartAssistant(startTime: nil, sensitivity: sensitivity.value)

    let message: [String: Any] = [RawData.updateSmartAssistantSensivity: startSmartAssistantData.toJSON()]
    self.sessionManager?.session.sendMessage(message, replyHandler: { (message) in
      log.info("Stop: \(message)")
    })
  }

  private func startInitialTimer(with startTime: StartTime) -> Observable<Int> {
    return Observable<Int>
      .timer(startTime.secondsLeft(), scheduler: MainScheduler.instance)
      .do(onNext: handleTimerStarted)
//      .flatMap { (_) -> Observable<Int> in
//        .timer(self.startTimerDuration, scheduler:  MainScheduler.instance)
//      }
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
    sendStopAssistantMessage(statistics: statistics)
    processedDataCollector?.isEnabled.value = false
  }
}
