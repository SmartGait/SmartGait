//
//  DeviceMotionAcceleration.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 26/01/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreMotion

struct DeviceMotionAcceleration: Mappable {
  var x: Double!
  var y: Double!
  var z: Double!

  init(x: Double, y: Double, z: Double) {
    self.x = x
    self.y = y
    self.z = z
  }
}

extension DeviceMotionAcceleration {
  init?(map: Map) {

  }

  mutating func mapping(map: Map) {
    x         <- map["x"]
    y         <- map["y"]
    z         <- map["z"]
  }
}

extension DeviceMotionAcceleration {
  init(_ acceleration: CMAcceleration) {
    x = acceleration.x
    y = acceleration.y
    z = acceleration.z
  }

  init(_ rotationRate: CMRotationRate) {
    x = rotationRate.x
    y = rotationRate.y
    z = rotationRate.z
  }
}
