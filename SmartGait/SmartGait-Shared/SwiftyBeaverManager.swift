//
//  SwiftyBeaverManager.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 12/02/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import SwiftyBeaver

let log = SwiftyBeaver.self
let console = ConsoleDestination()  // log to Xcode Console
let file = FileDestination()
let cloud = SBPlatformDestination(appID: "53090p",
                                  appSecret: "D0cy04fT6btpzs1hmGPsssybktk9PymD",
                                  encryptionKey: "Yn9k1AsfuczbkObzmRebyrfuhynirreu")
struct SwiftyBeaverManager {
  static let sharedInstance = SwiftyBeaverManager()

  private init() {
    log.addDestination(console)
    log.addDestination(file)
    log.addDestination(cloud)
  }
}

