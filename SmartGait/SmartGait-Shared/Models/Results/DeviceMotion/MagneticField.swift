//
//  MagneticField.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 26/01/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreMotion

struct MagneticField: Mappable {
  var x: Double!
  var y: Double!
  var z: Double!
  var accuracy: Int!

  init(x: Double, y: Double, z: Double, accuracy: Int) {
    self.x = x
    self.y = y
    self.z = z
    self.accuracy = accuracy
  }
}

extension MagneticField {
  init?(map: Map) {

  }

  mutating func mapping(map: Map) {
    x         <- map["x"]
    y         <- map["y"]
    z         <- map["z"]
    accuracy  <- map["accuracy"]
  }
}

extension MagneticField {
  init(_ magneticField: CMCalibratedMagneticField) {
    x = magneticField.field.x
    y = magneticField.field.y
    z = magneticField.field.z
    accuracy = Int(magneticField.accuracy.rawValue)
  }
}
