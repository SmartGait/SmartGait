//
//  StartTime.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 10/02/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import ObjectMapper

struct StartTime: Mappable {
  var time: Double!

  func secondsLeft() -> TimeInterval {
    let timeIntervalSince1970 = Date(timeIntervalSince1970: time)
    let timeLeft = timeIntervalSince1970.timeIntervalSince(Date())
    return timeLeft >= 0 ? timeLeft : 0
  }
}

extension StartTime {
  init?(map: Map) {

  }

  mutating func mapping(map: Map) {
    time <- map["time"]
  }
}
