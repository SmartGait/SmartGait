//
//  DeviceMotionResult.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 26/01/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreData
import Foundation
import ObjectMapper

struct DeviceMotionResult: TaskResult {
  var identifier: String!
  var startDate: Date!
  var endDate: Date!
  var fileURL: URL?

  var data: DeviceMotionItems?

  mutating func fetchData() {
    guard let jsonString = try? fileURL?.json() else {
      return
    }

    data = DeviceMotionItems(JSONString: String(describing: jsonString))
  }
}

extension DeviceMotionResult {
  init?(map: Map) {

  }

  mutating func mapping(map: Map) {
    identifier <- map["identifier"]
    startDate <- (map["startDate"], DateTransform())
    endDate <- (map["endDate"], DateTransform())
    data <- map["deviceMotionItems"]
  }
}
