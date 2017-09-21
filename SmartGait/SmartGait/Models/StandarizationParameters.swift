//
//  StandarizationParameters.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 01/05/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import ObjectMapper

struct StandarizationParameters: Mappable {
  var index: Int!
  var average: Double!
  var standardDeviation: Double!
}

extension StandarizationParameters {
  init?(map: Map) {

  }

  mutating func mapping(map: Map) {
    index <- map["index"]
    average <- map["average"]
    standardDeviation <- map["standardDeviation"]
  }
}
