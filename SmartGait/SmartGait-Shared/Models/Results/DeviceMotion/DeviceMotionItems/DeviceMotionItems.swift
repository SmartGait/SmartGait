//
//  DeviceMotionItems.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 26/01/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreData

struct DeviceMotionItems: Mappable {
  var items: [DeviceMotionData]!
}

extension DeviceMotionItems {
  init?(map: Map) {

  }

  mutating func mapping(map: Map) {
    items <- map["items"]
  }
}
