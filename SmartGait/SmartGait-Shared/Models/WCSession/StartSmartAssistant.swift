//
//  SmartAssistant.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 14/03/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import ObjectMapper

struct StartSmartAssistant: Mappable {
  var startTime: StartTime!
  var sensitivity: Float!
}

extension StartSmartAssistant {
  init?(map: Map) {

  }

  mutating func mapping(map: Map) {
    startTime <- map["startTime"]
    sensitivity <- map["sensitivity"]
  }
}
