//
//  UnixTimeOffset.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 16/02/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation

struct UnixTimeOffset {
  static var sharedInstance = UnixTimeOffset()

  lazy var offset: Double = {
    let uptime = ProcessInfo.processInfo.systemUptime
    let nowTimeIntervalSince1970 = Date().timeIntervalSince1970
    return nowTimeIntervalSince1970 - uptime
  }()

  private init() {

  }

  mutating func unixTimestamp(timestamp: Double) -> Double {
    return timestamp + offset
  }
}
