//
//  ClassificationTaskModel+Model.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 25/05/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation

extension ProcessedClassificationTaskModel {
  func map() throws -> ClassificationTask<ProcessedData, ProcessedClassificationTaskModel> {
    guard let identifier = identifier, let startDate = startDate else {
      throw "Couldn't map \(self)"
    }

    return ClassificationTask(id: Int(id),
                              identifier: identifier,
                              mergedData: try mergedData?
                                .allObjects.flatMap { try ($0 as? ProcessedMergedDataModel)?.map() } ?? [],
                              startDate: startDate as Date,
                              endDate: endDate as Date?)
  }
}

extension ProcessedMergedDataModel {
  func map() throws -> MergedData<ProcessedData> {
    guard let dataClassification = dataClassification,
      let classification = Classification(rawValue: dataClassification),
      let iOSData = try iOSProcessedData?.map(),
      let watchOSData = try watchOSProcessedData?.map() else {
      throw "Couldn't map \(self)"
    }

    return MergedData(iOSData: iOSData,
                      watchOSData: watchOSData,
                      dataClassification: DataClassification(classification: classification),
                      classificationSummary: summary,
                      currentActivity: currentActivity)
  }
}

extension ProcessedDataModel {
  func map() throws -> ProcessedData {
    let max = ThreeDVector(x: maxX, y: maxY, z: maxZ)
    let min = ThreeDVector(x: maxX, y: maxY, z: maxZ)
    let diffMaxMin = ThreeDVector(x: maxX, y: maxY, z: maxZ)
    let averageGravity = ThreeDVector(x: maxX, y: maxY, z: maxZ)
    let diffAverageGravity = ThreeDVector(x: maxX, y: maxY, z: maxZ)
    let standardDeviation = ThreeDVector(x: maxX, y: maxY, z: maxZ)
    let rms = ThreeDVector(x: maxX, y: maxY, z: maxZ)
    let sumOfDifferences = ThreeDVector(x: maxX, y: maxY, z: maxZ)

    guard let currentActivity = currentActivity else {
      throw "Couldn't map \(self)"
    }

    return ProcessedData(
      identifier: Int(identifier),
      initialTimestamp: initialTimestamp,
      finalTimestamp: finalTimestamp,
      max: max,
      min: min,
      diffMaxMin: diffMaxMin,
      averageGravity: averageGravity,
      diffAverageGravity: diffAverageGravity,
      standardDeviation: standardDeviation,
      rms: rms,
      sumOfDifferences: sumOfDifferences,
      sumOfMagnitudeDiffs: sumOfMagnitudeDiffs,
      currentActivity: try MotionActivity.map(description: currentActivity),
      samplesUsed: Int(samplesUsed)
    )
  }
}
