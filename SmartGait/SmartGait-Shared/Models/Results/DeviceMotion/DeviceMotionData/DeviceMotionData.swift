//
//  DeviceMotionData.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 26/01/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreData

struct DeviceMotionData: Mappable {
  var attitude: Attitude!
  var rotationRate: DeviceMotionAcceleration!
  var userAcceleration: DeviceMotionAcceleration!
  var gravity: DeviceMotionAcceleration!
  var magneticField: MagneticField!

  var timestamp: Double!
}

extension DeviceMotionData {
  init?(map: Map) {

  }

  mutating func mapping(map: Map) {
    attitude         <- map["attitude"]
    rotationRate     <- map["rotationRate"]
    userAcceleration <- map["userAcceleration"]
    gravity          <- map["gravity"]
    magneticField    <- map["magneticField"]
    timestamp        <- map["timestamp"]
  }
}
