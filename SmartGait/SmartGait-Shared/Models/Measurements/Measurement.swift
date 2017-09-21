//
//  Measurement.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 25/01/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import CoreMotion
import CoreData

struct Measurement {
  let timestamp: NSDate
  let acceleration: CMAcceleration
  let rotationRate: CMRotationRate
  let attitude: CMAttitude
  let dmRotationRate: CMRotationRate
  let userAcceleration: CMAcceleration
  let gravity: CMAcceleration

  func getCoreDataObject(for context: NSManagedObjectContext) -> MeasurementModel? {
    let measurementModel = NSEntityDescription
      .insertNewObject(forEntityName: "MeasurementModel", into: context) as? MeasurementModel

    measurementModel?.timestamp = timestamp
    measurementModel?.accelerationX = acceleration.x
    measurementModel?.accelerationY = acceleration.y
    measurementModel?.accelerationZ = acceleration.z
    measurementModel?.rotationRateX = rotationRate.x
    measurementModel?.rotationRateY = rotationRate.y
    measurementModel?.rotationRateZ = rotationRate.z
    measurementModel?.attitudePitch = attitude.pitch
    measurementModel?.attitudeYaw = attitude.yaw
    measurementModel?.attitudeRoll = attitude.roll
    measurementModel?.dmRotationRateX = dmRotationRate.x
    measurementModel?.dmRotationRateY = dmRotationRate.y
    measurementModel?.dmRotationRateZ = dmRotationRate.z
    measurementModel?.userAccelerationX = userAcceleration.x
    measurementModel?.userAccelerationY = userAcceleration.y
    measurementModel?.userAccelerationZ = userAcceleration.z
    measurementModel?.gravityX = gravity.x
    measurementModel?.gravityY = gravity.y
    measurementModel?.gravityZ = gravity.z

    return measurementModel
  }
}
