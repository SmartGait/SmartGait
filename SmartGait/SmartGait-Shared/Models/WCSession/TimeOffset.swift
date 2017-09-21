//
//  TimeOffset.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 09/02/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import ObjectMapper

struct TimeOffset: Mappable {
  var tOffset: TimeInterval!
}

extension TimeOffset {
  init?(map: Map) {

  }

  mutating func mapping(map: Map) {
    tOffset <- map["tOffset"]
  }
}
