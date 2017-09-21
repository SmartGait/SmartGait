//
//  MenuInterfaceController.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 14/03/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import WatchKit
import RxSwift
import WatchConnectivity
import WatchKit

class MenuInterfaceController: WKInterfaceController {
  @IBOutlet var infoLabel: WKInterfaceLabel!
  @IBOutlet var researchButton: WKInterfaceButton!
  @IBOutlet var smartAssistantButton: WKInterfaceButton!

  fileprivate var sessionManager: WCSessionManager?
  fileprivate var latency = Variable<Latency?>(nil)

  override func awake(withContext context: Any?) {
    do {
      self.sessionManager = try WCSessionManager.sharedInstanceFunc()
    } catch let error {
      print("Menu Interface: \(error)")
    }

    sessionManager?.isReachable()
      .filter { $0 }
      .take(1)
      .do(onNext: { _ in
//        self.calculateMessageDelay()
        //UI
        self.infoLabel.setHidden(true)
        self.researchButton.setHidden(false)
        self.smartAssistantButton.setHidden(false)
      })
      .subscribe()
      .addDisposableTo(rx_disposeBag)
  }

  override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
    return latency.value
  }
}

extension MenuInterfaceController {
  private struct Message {
    let tPhone1: TimeInterval
    let tSensor2: TimeInterval
    let tPhone3: TimeInterval
  }

  fileprivate func calculateMessageDelay() {
    let messages: Variable<[Message]> = Variable([])
    let index = Variable(0)
    let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)
    infoLabel.setText("Calibrating... 0%")

    index
      .asObservable()
      .observeOn(scheduler)
      .filter { $0 < 100 }
      .do(onNext: { _ in
        self.sendMessage(messages: messages, index: index)
      })
      .observeOn(MainScheduler.instance)
      .do(onNext: { _ in
        self.infoLabel.setText("Calibrating... \(index.value)%")
      })
      .subscribe()
      .addDisposableTo(rx_disposeBag)

    index
      .asObservable()
      .observeOn(scheduler)
      .filter { $0 >= 100 }
      .do(onNext: { _ in
        self.latency.value = self.calculateLatency(forMessages: messages.value)
      })
      .observeOn(MainScheduler.instance)
      .do(onNext: { _ in
        //UI
        self.infoLabel.setHidden(true)
        self.researchButton.setHidden(false)
        self.smartAssistantButton.setHidden(false)
      })
      .subscribe()
      .addDisposableTo(rx_disposeBag)
  }

  private func sendMessage(messages: Variable<[Message]>, index: Variable<Int>) {
    let request = ["timeOffset": ["": ""]]

    let tPhone1 = Date().timeIntervalSince1970
    self.sessionManager?.session.sendMessage(request, replyHandler: { (message) in
      let tPhone3 = Date().timeIntervalSince1970
      guard let tSensor2JSON = message["tSensor2"] as? [String: Any],
        let timeOffset = TimeOffset(JSON: tSensor2JSON) else {
          return
      }

      let messageReceived = Message(tPhone1: tPhone1, tSensor2: timeOffset.tOffset, tPhone3: tPhone3)
      messages.value.append(messageReceived)
      index.value += 1
    })
  }

  private func calculateLatency(forMessages messages: [Message]) -> Latency? {
    let tDelay = messages
      .reduce(0) { (result, message) -> TimeInterval in
        return result + (message.tPhone3 - message.tPhone1)
      } / Double(2 * messages.count)

    let offsets = messages.map { ($0.tPhone1 + tDelay) - $0.tSensor2 }
    return Latency(from: offsets)
  }
}
