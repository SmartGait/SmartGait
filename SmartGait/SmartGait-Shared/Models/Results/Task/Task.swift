//
//  Task.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 26/01/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreData
import Foundation
import ObjectMapper

struct Task: Mappable {
  var identifier: String!
  var startDate: Date!
  var endDate: Date!
  var steps: [Step]!

  init(identifier: String, startDate: Date, endDate: Date, steps: [Step]) {
    self.identifier = identifier
    self.startDate = startDate
    self.endDate = endDate
    self.steps = steps
  }

  mutating func fetchData() {
    steps = steps.map({ (step) -> Step in
      var step = step
      step.fetchData()
      return step
    })
  }
}

extension Task {
  init?(map: Map) {

  }

  mutating func mapping(map: Map) {
    identifier <- map["identifier"]
    startDate <- (map["startDate"], DateTransform())
    endDate <- (map["endDate"], DateTransform())
    steps <- map["steps"]
  }
}
