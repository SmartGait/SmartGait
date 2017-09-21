//
//  ExtensionDelegate.swift
//  SmartGait-WatchOS Extension
//
//  Created by Francisco Gonçalves on 02/02/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import AVFoundation
import NSObject_Rx
import Result
import RxSwiftExt
import WatchKit
import HealthKit
import RxSwift

class ExtensionDelegate: NSObject, WKExtensionDelegate, HKWorkoutSessionDelegate, AVSpeechSynthesizerDelegate {
  let synth = AVSpeechSynthesizer()
  var workoutSession: HKWorkoutSession!
  let healthStore = HKHealthStore()
  let logManager = SwiftyBeaverManager.sharedInstance
  var sessionManager: WCSessionManager? //= WCSessionManager.sharedInstance
  var watchdog: Watchdog?

  func applicationDidFinishLaunching() {
    // Perform any final initialization of your application.
    synth.delegate = self
    startWorkout()
    
    Observable
      .just(0)
      .observeOn(MainScheduler.instance)
      .do(onNext: { (_) in
        do {
          self.sessionManager = try WCSessionManager.sharedInstanceFunc()
        } catch let error {
          print("Extension Delegate: \(error)")
        }
      })
      .subscribe()
      .addDisposableTo(rx_disposeBag)

    sessionManager? 
      .session
      .rx.reachabilityDidChange
      .debug()
      .subscribe()
      .addDisposableTo(rx_disposeBag)

    sessionManager?
      .session
      .rx.activationDidComplete
      .debug()
      .subscribe()
      .addDisposableTo(rx_disposeBag)

    let userDefaults = UserDefaults.standard
    userDefaults.set(["pt-PT", "en"], forKey: "AppleLanguages")
    userDefaults.synchronize()
  }

  func applicationDidBecomeActive() {
    // Restart any tasks that were paused (or not yet started) while the application was inactive.
    // If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillResignActive() {
    // Sent when the application is about to move from active to inactive state.
    // This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message)
    // or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, etc.
  }

  func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
    // Sent when the system needs to launch the application in the background to process tasks.
    // Tasks arrive in a set, so loop through and process each one.
    for task in backgroundTasks {
      // Use a switch statement to check the task type
      switch task {
      case let backgroundTask as WKApplicationRefreshBackgroundTask:
        // Be sure to complete the background task once you’re done.
        backgroundTask.setTaskCompleted()
      case let snapshotTask as WKSnapshotRefreshBackgroundTask:
        // Snapshot tasks have a unique completion call, make sure to set your expiration date
        snapshotTask.setTaskCompleted(restoredDefaultState: true,
                                      estimatedSnapshotExpiration: Date.distantFuture,
                                      userInfo: nil)
      case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
        // Be sure to complete the connectivity task once you’re done.
        connectivityTask.setTaskCompleted()
      case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
        // Be sure to complete the URL session task once you’re done.
        urlSessionTask.setTaskCompleted()
      default:
        // make sure to complete unhandled task types
        task.setTaskCompleted()
      }
    }
  }

}

extension ExtensionDelegate {
  public func workoutSession(_ workoutSession: HKWorkoutSession,
                             didChangeTo toState: HKWorkoutSessionState,
                             from fromState: HKWorkoutSessionState, date: Date) {
    log.info("change to \(toState.rawValue) from \(fromState.rawValue)")
  }

  public func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
    log.error("failed with error \(error)")
  }

  func startWorkout() {
    guard workoutSession == nil else {
      return
    }

    let configuration = HKWorkoutConfiguration()
    configuration.activityType = .walking
    configuration.locationType = .indoor

    do {
      workoutSession = try HKWorkoutSession(configuration: configuration)

      workoutSession.delegate = self
      healthStore.start(workoutSession)

    } catch let error as NSError {
      // Perform proper error handling here...
      fatalError("*** Unable to create the workout session: \(error.localizedDescription) ***")
    }
  }

  func stopWorkout() {
    healthStore.end(workoutSession)
    workoutSession = nil
  }
}

extension ExtensionDelegate {
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
  }

  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
    log.error("speech did paused")
  }

  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
    log.error("speech did continue")
  }

  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
    log.error("speech did cancel")
  }
}
