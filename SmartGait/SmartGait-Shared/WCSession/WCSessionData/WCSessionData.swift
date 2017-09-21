//
//  WCSessionData.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 09/02/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol WCSessionDataHandeable {
  typealias JSON = [String: Any]

  func handle(message: JSON, replyHandler: @escaping ([String : Any]) -> Void) throws
  func handle(file: URL) throws
}

enum WCSessionData: String, WCSessionDataHandeable {
  typealias JSON = [String: Any]

  case timeOffset
  case startShortWalk
  case startNextStep

  case startRawSmartAssistant
  case resumeRawSmartAssistant
  case stopRawSmartAssistant
  case smartAssistantRawData
  case updateSmartAssistantRawSensivity

  case startProcessedSmartAssistant
  case resumeProcessedSmartAssistant
  case stopProcessedSmartAssistant
  case smartAssistantProcessedData

  case saveTask
  case error
}
