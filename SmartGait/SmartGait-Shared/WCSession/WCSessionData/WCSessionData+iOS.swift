//
//  WCSessionData+iOS.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 11/02/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension WCSessionData {

  //swiftlint:disable cyclomatic_complexity
  func handle(message: JSON, replyHandler: @escaping ([String : Any]) -> Void) throws {
    switch self {
    case .timeOffset:
      try handleTimeOffset(message: message, withReplyHandler: replyHandler)

    case .startShortWalk:
      try handleStartShortWalk(message: message, withReplyHandler: replyHandler)
    case .startNextStep:
      try handleNextStep(message: message, withReplyHandler: replyHandler)

    case .startRawSmartAssistant:
      try handleStartRawSmartAssistant(message: message, withReplyHandler: replyHandler)
    case .resumeRawSmartAssistant:
      try handleResumeRawSmartAssistant(message: message, withReplyHandler: replyHandler)
    case .stopRawSmartAssistant:
      try handleStopRawSmartAssistant(message: message, withReplyHandler: replyHandler)
    case .smartAssistantRawData:
      try handleSmartAssistantRawData(message: message, withReplyHandler: replyHandler)
    case .updateSmartAssistantRawSensivity:
      try handleUpdateSmartAssistantRawSensivity(message: message, withReplyHandler: replyHandler)

    case .startProcessedSmartAssistant:
      try handleStartProcessedSmartAssistant(message: message, withReplyHandler: replyHandler)
    case .resumeProcessedSmartAssistant:
      try handleResumeProcessedSmartAssistant(message: message, withReplyHandler: replyHandler)
    case .stopProcessedSmartAssistant:
      try handleStopProcessedSmartAssistant(message: message, withReplyHandler: replyHandler)
    case .smartAssistantProcessedData:
      try handleSmartAssistantProcessedData(message: message, withReplyHandler: replyHandler)

    case .error:
      try handleError(message: message)
    default:
      throw "Couldn't handle case"
    }
  }

  func handle(message: String, replyHandler: @escaping ([String : Any]) -> Void) throws {
    switch self {
    case .smartAssistantRawData:
      guard let rawData = RawData(JSONString: message) else {
        throw "Couldn't parse Smart Assistant JSON"
      }

      let smartAssistantViewController = try fetchRawSmartAssistantViewController()
      smartAssistantViewController.handle(processedData: rawData, replyHandler: replyHandler)
    default:
      throw "String handle not implemented"
    }
  }

  func handle(file: URL) throws {
    switch self {
    case .saveTask:
      try handleSaveTask(file: file)
    default:
      throw "Couldn't handle case"
    }
  }
}

extension WCSessionData {
  func handleTimeOffset(message: JSON,
                        withReplyHandler replyHandler: @escaping ([String : Any]) -> Void) throws {
    let offset = TimeOffset(tOffset: Date().timeIntervalSince1970)
    replyHandler(["tSensor2": offset.toJSON()])
  }
}

extension WCSessionData {
  func handleStartShortWalk(message: JSON,
                            withReplyHandler replyHandler: @escaping ([String : Any]) -> Void) throws {
    guard let shortWalk = ShortWalk(JSON: message) else {
      throw "Couldn't parse Short Walk JSON"
    }

    replyHandler(["arrived at": Date().timeIntervalSince1970])

    let researchViewController = try fetchResearchViewController()

    researchViewController.startTask(withStartTime: shortWalk.startTime ?? StartTime(time: 0),
                                     numberOfStepsPerLeg: shortWalk.numberOfStepsPerLeg,
                                     restDuration: shortWalk.restDuration)
  }

  func handleNextStep(message: JSON,
                      withReplyHandler replyHandler: @escaping ([String : Any]) -> Void) throws {
    guard let startTime = StartTime(JSON: message) else {
      throw "Couldn't parse Start Time JSON"
    }

    replyHandler(["arrived at": Date().timeIntervalSince1970])
    print(replyHandler)

    let researchViewController = try fetchResearchViewController()

    researchViewController.startNextStep(at: startTime)
  }

}

extension WCSessionData {
  func handleStartProcessedSmartAssistant(message: JSON,
                                          withReplyHandler replyHandler: @escaping ([String : Any]) -> Void) throws {
    guard let smartAssistant = StartSmartAssistant(JSON: message) else {
      throw "Couldn't parse Smart Assistant JSON"
    }

    replyHandler(["arrived at": Date().timeIntervalSince1970])

    let smartAssistantViewController = try fetchProcessedSmartAssistantViewController()
    smartAssistantViewController.start(data: smartAssistant)
  }

  func handleResumeProcessedSmartAssistant(message: JSON,
                                           withReplyHandler replyHandler: @escaping ([String : Any]) -> Void) throws {

    let smartAssistantViewController = try fetchProcessedSmartAssistantViewController()
    smartAssistantViewController.resume()
  }

  func handleStopProcessedSmartAssistant(message: JSON,
                                         withReplyHandler replyHandler: @escaping ([String : Any]) -> Void) throws {
    replyHandler(["arrived at": Date().timeIntervalSince1970])

    let smartAssistantViewController = try fetchProcessedSmartAssistantViewController()
    smartAssistantViewController.stop()
  }

  func handleSmartAssistantProcessedData(message: JSON,
                                         withReplyHandler replyHandler: @escaping ([String : Any]) -> Void) throws {
    guard let processedData = ProcessedData(JSON: message) else {
      throw "Couldn't parse Smart Assistant JSON"
    }

    let smartAssistantViewController = try fetchProcessedSmartAssistantViewController()
    smartAssistantViewController.handle(processedData: processedData, replyHandler: replyHandler)
  }
}

extension WCSessionData {
  func handleStartRawSmartAssistant(message: JSON,
                                    withReplyHandler replyHandler: @escaping ([String : Any]) -> Void) throws {
    guard let smartAssistant = StartSmartAssistant(JSON: message) else {
      throw "Couldn't parse Smart Assistant JSON"
    }

    replyHandler(["arrived at": Date().timeIntervalSince1970])

    let smartAssistantViewController = try fetchRawSmartAssistantViewController()
    smartAssistantViewController.start(data: smartAssistant)
  }

  func handleResumeRawSmartAssistant(message: JSON,
                                     withReplyHandler replyHandler: @escaping ([String : Any]) -> Void) throws {

    let smartAssistantViewController = try fetchRawSmartAssistantViewController()
    smartAssistantViewController.resume()
  }

  func handleStopRawSmartAssistant(message: JSON,
                                   withReplyHandler replyHandler: @escaping ([String : Any]) -> Void) throws {
    replyHandler(["arrived at": Date().timeIntervalSince1970])
    print(message)
    let smartAssistantViewController = try fetchRawSmartAssistantViewController()
    smartAssistantViewController.stop()
  }

  func handleSmartAssistantRawData(message: JSON,
                                   withReplyHandler replyHandler: @escaping ([String : Any]) -> Void) throws {
    guard let rawData = RawData(JSON: message) else {
      throw "Couldn't parse Smart Assistant JSON"
    }

    print("HANDLE WITH ID \(rawData.identifier)")
    let smartAssistantViewController = try fetchRawSmartAssistantViewController()
    smartAssistantViewController.handle(processedData: rawData, replyHandler: replyHandler)
  }

  func handleUpdateSmartAssistantRawSensivity(message: JSON,
                                              withReplyHandler replyHandler: @escaping ([String : Any]) -> Void) throws {
    guard let smartAssistant = StartSmartAssistant(JSON: message) else {
      throw "Couldn't parse Smart Assistant JSON"
    }

    replyHandler(["arrived at": Date().timeIntervalSince1970])

    let smartAssistantViewController = try fetchRawSmartAssistantViewController()
    smartAssistantViewController.updateSensivity(data: smartAssistant)
  }
}

extension WCSessionData {
  func handleSaveTask(file: URL) throws {
    let taskJSONString = try String(contentsOfFile: file.path, encoding: String.Encoding.utf8)

    guard let task = Task(JSONString: taskJSONString) else {
      throw "Couldn't parse Task JSON"
    }

    CoreDataManager.sharedInstance.saveToCoreData(task: task)
  }

  func handleError(message: JSON) throws {
    guard let error = message["error"] as? String else {
      throw "Couldn't parse Error"
    }

    log.error(error)
  }

  fileprivate func fetchProcessedSmartAssistantViewController() throws -> ProcessedSyncedSmartAssistantViewController {
    let index = TabBarViewControllersIndex.processedSyncedSmartAssistViewController

    guard let navController = try getController(forIndex: index) as? UINavigationController,
      let controller = navController.viewControllers.last as? ProcessedSyncedSmartAssistantViewController else {
        throw "Failed getting ProcessedSyncedSmartAssistantViewController"
    }

    return controller
  }

  fileprivate func fetchRawSmartAssistantViewController() throws -> RawSyncedSmartAssistantViewController {
    let index = TabBarViewControllersIndex.rawSyncedSmartAssistViewController

    guard let navController = try getController(forIndex: index) as? UINavigationController,
      let controller = navController.viewControllers.last as? RawSyncedSmartAssistantViewController else {
        throw "Failed getting RawSyncedSmartAssistantViewController"
    }

    return controller
  }

  fileprivate func fetchResearchViewController() throws -> ResearchViewController {
    let index = TabBarViewControllersIndex.researchViewController

    guard let controller = try getController(forIndex: index) as? ResearchViewController else {
      throw "Failed getting ResearchViewController"
    }

    return controller
  }

  private func getController(forIndex index: TabBarViewControllersIndex) throws -> UIViewController? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      throw "Failed getting AppDelegate"
    }

    let tabController = appDelegate.window?.rootViewController as? UITabBarController

    tabController?.selectedIndex = index.rawValue

    return tabController?.viewControllers?[index.rawValue]
  }
}

enum TabBarViewControllersIndex: Int {
  case researchViewController
  case rawSyncedSmartAssistViewController
  case processedSyncedSmartAssistViewController
  case iPhoneOnlySmartAssistViewController
  case processedSmartAssistantHistory
  case measurementsViewController
  case researchHistory
}
