//
//  ShortWalk.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 09/02/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import ObjectMapper

struct ShortWalk: Mappable {
  var startTime: StartTime!
  var numberOfStepsPerLeg: Int!
  var restDuration: TimeInterval!
}

extension ShortWalk {
  init?(map: Map) {

  }

  mutating func mapping(map: Map) {
    startTime <- map["startTime"]
    numberOfStepsPerLeg <- map["numberOfStepsPerLeg"]
    restDuration <- map["restDuration"]
  }
}
