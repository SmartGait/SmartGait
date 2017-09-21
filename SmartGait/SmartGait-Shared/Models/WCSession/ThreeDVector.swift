//
//  ThreeDVector.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 01/05/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import ObjectMapper

struct ThreeDVector: Mappable {
  var x: Double!
  var y: Double!
  var z: Double!
}

extension ThreeDVector {
  init?(map: Map) {

  }

  mutating func mapping(map: Map) {
    x <- map["x"]
    y <- map["y"]
    z <- map["z"]
  }
}
