//
//  AccelerometerItems.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 26/01/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreData

struct AccelerometerItems: Mappable {
  var items: [AccelerometerData]!
}

extension AccelerometerItems {
  init?(map: Map) {

  }

  mutating func mapping(map: Map) {
    items <- map["items"]
  }
}
