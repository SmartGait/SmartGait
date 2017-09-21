//
//  DataClassification.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 27/03/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import ObjectMapper

enum Classification: String {
  case balanced
  case imbalanced
}

struct DataClassification: Mappable {
  var classification: Classification!

  init(classification: Classification) {
    self.classification = classification
  }
}

extension DataClassification {
  init?(map: Map) {

  }

  mutating func mapping(map: Map) {
    classification <- (map["classification"], EnumTransform<Classification>())
  }
}

extension DataClassification {
  static func classify(processedData: ProcessedData) -> ProcessedData {
    var processedData = processedData
    guard let classification: Classification = ProcessedData.applyStaticClassification(data: processedData) else {
      return processedData
    }

    processedData.updateClassification(dataClassification: DataClassification(classification: classification))
    return processedData
  }

  static func classify<MD: MotionData>(mergedData: MergedData<MD>) -> MergedData<MD> {
    var mergedData = mergedData
    guard let iOSClassification = MD.applyStaticClassification(data: mergedData.iOSData),
      let watchOSClassification = MD.applyStaticClassification(data: mergedData.watchOSData) else {
      return mergedData
    }
    var classification: Classification = .balanced

    if iOSClassification == .imbalanced || watchOSClassification == .imbalanced {
      classification = .imbalanced
    }
    mergedData.updateClassification(dataClassification: DataClassification(classification: classification))
    return mergedData
  }
}
