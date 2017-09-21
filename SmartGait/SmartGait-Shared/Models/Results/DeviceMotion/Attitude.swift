//
//  Attitude.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 26/01/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreMotion

struct Attitude: Mappable {
  var x: Double!
  var y: Double!
  var z: Double!
  var w: Double!

  init(x: Double, y: Double, z: Double, w: Double) {
    self.x = x
    self.y = y
    self.z = z
    self.w = w
  }
}

extension Attitude {
  init?(map: Map) {

  }

  mutating func mapping(map: Map) {
    x <- map["x"]
    y <- map["y"]
    z <- map["z"]
    w <- map["w"]
  }
}

extension Attitude {
  init(_ attitude: CMAttitude) {
    x = attitude.quaternion.x
    y = attitude.quaternion.y
    z = attitude.quaternion.z
    w = attitude.quaternion.w
  }
}
