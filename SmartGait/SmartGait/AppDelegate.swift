//
//  AppDelegate.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 24/01/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import UIKit
import CoreData
import LNRSimpleNotifications
import NSObject_Rx
import Result
import RxSwiftExt
import WatchConnectivity
import Watchdog
import CoreML

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var watchdog: Watchdog?
  var session: WCSessionManager?
  let notificationManager = NotificationManager.sharedInstance
  let constants = Constants.sharedInstance

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    log.addDestination(console)
    log.addDestination(cloud)

    do {
      self.session = try WCSessionManager.sharedInstanceFunc()
    } catch let error {
      print("AppDelegate: \(error)")
    }

    session?.session
      .rx
      .didBecomeInactive
      .debug()
      .subscribe()
      .addDisposableTo(rx_disposeBag)

    session?.session
      .rx
      .activationDidComplete
      .debug()
      .subscribe()
      .addDisposableTo(rx_disposeBag)

    session?.session
      .rx
      .reachabilityDidChange
      .debug()
      .subscribe()
      .addDisposableTo(rx_disposeBag)

    session?.session
      .rx
      .watchStateDidChange
      .debug()
      .subscribe()
      .addDisposableTo(rx_disposeBag)

    let userDefaults = UserDefaults.standard
    userDefaults.set(["pt-PT", "en"], forKey: "AppleLanguages")
    userDefaults.synchronize()

    return true
  }

  func applicationWillTerminate(_ application: UIApplication) {
    constants.saveCurrentIds()
    CoreDataManager.sharedInstance.save(context: CoreDataManager.sharedInstance.viewContext)
    CoreDataManager.sharedInstance.save(context: CoreDataManager.sharedInstance.backgroundContext)
  }
}
