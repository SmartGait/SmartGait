//
//  DeviceMotionData+CoreData.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 03/02/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import CoreData

// MARK: - CoreData
extension DeviceMotionData {
  func getCoreDataObject(for context: NSManagedObjectContext) -> DeviceMotionModel? {
    let model = NSEntityDescription
      .insertNewObject(forEntityName: "DeviceMotionModel", into: context) as? DeviceMotionModel

    model?.attitudeX = attitude.x
    model?.attitudeY = attitude.y
    model?.attitudeZ = attitude.z
    model?.attitudeW = attitude.w

    model?.rotationRateX = rotationRate.x
    model?.rotationRateY = rotationRate.y
    model?.rotationRateZ = rotationRate.z

    model?.userAccelerationX = userAcceleration.x
    model?.userAccelerationY = userAcceleration.y
    model?.userAccelerationZ = userAcceleration.z

    model?.gravityX = gravity.x
    model?.gravityY = gravity.y
    model?.gravityZ = gravity.z

    model?.magneticFieldX = magneticField.x
    model?.magneticFieldY = magneticField.y
    model?.magneticFieldZ = magneticField.z
    model?.magneticFieldAccuracy = Int16(magneticField.accuracy)

    model?.timestamp = timestamp

    return model
  }
}
