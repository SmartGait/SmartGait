//
//  RawData+CoreData.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 04/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreData
import Foundation

// MARK: CoreData
extension RawData {
  func getCoreDataObject(for context: NSManagedObjectContext) -> ClassificationDataModel? {
    let model = NSEntityDescription
      .insertNewObject(forEntityName: "RawDataModel", into: context) as? RawDataModel

    model?.dataClassification = dataClassification?.classification.rawValue
    model?.identifier = Int64(identifier)
    model?.initialTimestamp = initialTimestamp
    model?.finalTimestamp = finalTimestamp

    model?.motionData = Set(motionData.map { $0.getCoreDataObject(for: context) }.flatMap { $0 }) as NSSet

    model?.currentActivity = currentActivity.description()
    model?.samplesUsed = Int16(samplesUsed)

    return model
  }
}
