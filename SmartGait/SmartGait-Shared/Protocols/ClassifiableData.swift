//
//  MappableAsArray.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 02/05/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreData
import CoreML
import Foundation

protocol ClassifiableData {
  var dataClassification: DataClassification? { get set }

  func asArray() -> [[Double]]
  @available(watchOSApplicationExtension 4.0, *)
  func asMLMultiArray() throws -> [MLMultiArray]
  mutating func updateClassification(dataClassification: DataClassification?)
}

extension ClassifiableData {
  mutating func updateClassification(dataClassification: DataClassification?) {
    self.dataClassification = dataClassification
  }
}
