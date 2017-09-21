//
//  NotificationManager.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 13/02/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import AudioToolbox
import LNRSimpleNotifications

struct NotificationManager {
  static let sharedInstance = NotificationManager()
  private let notificationManager = LNRNotificationManager()

  private init() {
    notificationManager.notificationsPosition = .top
    notificationManager.notificationsBackgroundColor = UIColor.white
    notificationManager.notificationsTitleTextColor = UIColor.black
    notificationManager.notificationsBodyTextColor = UIColor.darkGray
    notificationManager.notificationsSeperatorColor = UIColor.gray

    if let alertSoundURL = Bundle.main.url(forResource: "click", withExtension: "wav") {
      var mySound: SystemSoundID = 0
      AudioServicesCreateSystemSoundID(alertSoundURL as CFURL, &mySound)
      notificationManager.notificationSound = mySound
    }
  }

  func show(notification: LNRNotification) {
    notificationManager.showNotification(notification: notification)
  }
}
