//
//  ProcessedData+CoreData.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 04/05/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreData
import Foundation

// MARK: CoreData
extension ProcessedData {
  func getCoreDataObject(for context: NSManagedObjectContext) -> ClassificationDataModel? {
    let model = NSEntityDescription
      .insertNewObject(forEntityName: "ProcessedDataModel", into: context) as? ProcessedDataModel

    model?.dataClassification = dataClassification?.classification.rawValue
    model?.identifier = Int64(identifier)
    model?.initialTimestamp = initialTimestamp
    model?.finalTimestamp = finalTimestamp
    model?.maxX = max.x
    model?.maxY = max.y
    model?.maxZ = max.z
    model?.minX = min.x
    model?.minY = min.y
    model?.minZ = min.z
    model?.diffMaxMinX = diffMaxMin.x
    model?.diffMaxMinY = diffMaxMin.y
    model?.diffMaxMinZ = diffMaxMin.z
    model?.averageGravityX = averageGravity.x
    model?.averageGravityY = averageGravity.y
    model?.averageGravityZ = averageGravity.z
    model?.diffAverageGravityX = diffAverageGravity.x
    model?.diffAverageGravityY = diffAverageGravity.y
    model?.diffAverageGravityZ = diffAverageGravity.z
    model?.standardDeviationX = standardDeviation.x
    model?.standardDeviationY = standardDeviation.y
    model?.standardDeviationZ = standardDeviation.z
    model?.rmsX = rms.x
    model?.rmsY = rms.y
    model?.rmsZ = rms.z
    model?.sumOfDifferencesX = sumOfDifferences.x
    model?.sumOfDifferencesY = sumOfDifferences.y
    model?.sumOfDifferencesZ = sumOfDifferences.z
    model?.sumOfMagnitudeDiffs = sumOfMagnitudeDiffs
    model?.currentActivity = currentActivity.description()
    model?.samplesUsed = Int16(samplesUsed)

    return model
  }
}
