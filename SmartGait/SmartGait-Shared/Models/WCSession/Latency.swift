//
//  Latency.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 07/02/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import ObjectMapper

struct Latency: Mappable {
  var min: Double!
  var max: Double!
  var avg: Double!

  init(min: Double, max: Double, avg: Double) {
    self.min = min
    self.max = max
    self.avg = avg
  }
}

extension Latency {
  init?(map: Map) {

  }

  mutating func mapping(map: Map) {
    min <- map["min"]
    max <- map["max"]
    avg <- map["avg"]
  }
}

extension Latency {
  init?(from offsets: [Double]) {
    guard let min = offsets.min(), let max = offsets.max(), let avg = offsets.avg() else {
      return nil
    }

    self.min = min
    self.max = max
    self.avg = avg
  }
}
