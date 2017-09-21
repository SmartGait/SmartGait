//
//  AccelerometerData.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 25/01/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreData
import CoreMotion

struct AccelerometerData: Mappable {
  var x: Double!
  var y: Double!
  var z: Double!

  var timestamp: Double!
}

extension AccelerometerData {
  init?(map: Map) {

  }

  mutating func mapping(map: Map) {
    x         <- map["x"]
    y         <- map["y"]
    z         <- map["z"]
    timestamp <- map["timestamp"]
  }
}

extension AccelerometerData {
  init(_ accelerometerData: CMAccelerometerData) {
    x = accelerometerData.acceleration.x
    y = accelerometerData.acceleration.y
    z = accelerometerData.acceleration.z
    timestamp = UnixTimeOffset.sharedInstance.unixTimestamp(timestamp: accelerometerData.timestamp)
  }
}
