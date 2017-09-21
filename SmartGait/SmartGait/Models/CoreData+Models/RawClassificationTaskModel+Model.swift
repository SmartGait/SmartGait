//
//  RawClassificationTaskModel.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 14/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation

extension RawClassificationTaskModel {
  func map() throws -> ClassificationTask<RawData, RawClassificationTaskModel> {
    guard let identifier = identifier, let startDate = startDate else {
      throw "Couldn't map \(self)"
    }

    return ClassificationTask(id: Int(id),
                              identifier: identifier,
                              mergedData: try mergedData?
                                .allObjects.flatMap { try ($0 as? RawMergedDataModel)?.map() } ?? [],
                              startDate: startDate as Date,
                              endDate: endDate as Date?)
  }
}

extension RawMergedDataModel {
  func map() throws -> MergedData<RawData> {
    guard let dataClassification = dataClassification,
      let classification = Classification(rawValue: dataClassification),
      let iOSData = try iOSRawData?.map(),
      let watchOSData = try watchOSRawData?.map() else {
        throw "Couldn't map \(self)"
    }

    return MergedData(iOSData: iOSData,
                      watchOSData: watchOSData,
                      dataClassification: DataClassification(classification: classification),
                      classificationSummary: summary,
                      currentActivity: currentActivity)
  }
}

extension RawDataModel {
  func map() throws -> RawData {

    guard let deviceMotionData = motionData?.allObjects as? [DeviceMotionModel],
      let currentActivity = currentActivity else {
      throw "Couldn't map \(self)"
    }

    return RawData(
      identifier: Int(identifier),
      initialTimestamp: initialTimestamp,
      finalTimestamp: finalTimestamp,
      motionData: try deviceMotionData.map { try $0.map() },
      currentActivity: try MotionActivity.map(description: currentActivity),
      samplesUsed: Int(samplesUsed)
    )
  }
}

extension DeviceMotionModel {
  func map() throws -> DeviceMotionData {
    let attitude = Attitude(x: attitudeX, y: attitudeY, z: attitudeZ, w: attitudeW)
    let rotationRate = DeviceMotionAcceleration(x: rotationRateX, y: rotationRateY, z: rotationRateZ)
    let userAcceleration = DeviceMotionAcceleration(x: userAccelerationX, y: userAccelerationY, z: userAccelerationZ)
    let gravity = DeviceMotionAcceleration(x: gravityX, y: gravityY, z: gravityZ)
    let magneticField = MagneticField(
      x: magneticFieldX,
      y: magneticFieldY,
      z: magneticFieldZ,
      accuracy: Int(magneticFieldAccuracy)
    )

    return DeviceMotionData(
      attitude: attitude,
      rotationRate: rotationRate,
      userAcceleration: userAcceleration,
      gravity: gravity,
      magneticField: magneticField,
      timestamp: timestamp
    )
  }
}
