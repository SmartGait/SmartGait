//
//  DeviceMotionModel+CoreDataProperties.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 26/01/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import CoreData

extension DeviceMotionModel {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<DeviceMotionModel> {
    return NSFetchRequest<DeviceMotionModel>(entityName: "DeviceMotionModel")
  }
  
  @NSManaged public var attitudeX: Double
  @NSManaged public var attitudeY: Double
  @NSManaged public var attitudeZ: Double
  @NSManaged public var attitudeW: Double
  @NSManaged public var rotationRateX: Double
  @NSManaged public var rotationRateY: Double
  @NSManaged public var rotationRateZ: Double
  @NSManaged public var userAccelerationX: Double
  @NSManaged public var userAccelerationY: Double
  @NSManaged public var userAccelerationZ: Double
  @NSManaged public var gravityX: Double
  @NSManaged public var gravityY: Double
  @NSManaged public var gravityZ: Double
  @NSManaged public var timestamp: Double
  @NSManaged public var magneticFieldX: Double
  @NSManaged public var magneticFieldY: Double
  @NSManaged public var magneticFieldZ: Double
  @NSManaged public var magneticFieldAccuracy: Int16
  @NSManaged public var deviceMotionResult: DeviceMotionResultModel?
  
}
