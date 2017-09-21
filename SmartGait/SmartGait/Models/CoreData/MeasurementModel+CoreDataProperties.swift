//
//  MeasurementModel+CoreDataProperties.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 26/01/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import CoreData

extension MeasurementModel {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<MeasurementModel> {
    return NSFetchRequest<MeasurementModel>(entityName: "MeasurementModel")
  }
  
  @NSManaged public var accelerationX: Double
  @NSManaged public var accelerationY: Double
  @NSManaged public var accelerationZ: Double
  @NSManaged public var attitudePitch: Double
  @NSManaged public var attitudeRoll: Double
  @NSManaged public var attitudeYaw: Double
  @NSManaged public var dmRotationRateX: Double
  @NSManaged public var dmRotationRateY: Double
  @NSManaged public var dmRotationRateZ: Double
  @NSManaged public var gravityX: Double
  @NSManaged public var gravityY: Double
  @NSManaged public var gravityZ: Double
  @NSManaged public var rotationRateX: Double
  @NSManaged public var rotationRateY: Double
  @NSManaged public var rotationRateZ: Double
  @NSManaged public var timestamp: NSDate?
  @NSManaged public var userAccelerationX: Double
  @NSManaged public var userAccelerationY: Double
  @NSManaged public var userAccelerationZ: Double
  
}
