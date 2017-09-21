//
//  Step.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 26/01/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreData
import Foundation
import ObjectMapper

struct Step: Mappable {
  var identifier: String!
  var accelerometer: AccelerometerResult!
  var deviceMotion: DeviceMotionResult!

  mutating func fetchData() {
    accelerometer.fetchData()
    deviceMotion.fetchData()
  }
}

extension Step {
  init?(map: Map) {

  }

  mutating func mapping(map: Map) {
    identifier <- map["identifier"]
    accelerometer <- map["accelerometerResult"]
    deviceMotion <- map["deviceMotionResult"]
  }
}
