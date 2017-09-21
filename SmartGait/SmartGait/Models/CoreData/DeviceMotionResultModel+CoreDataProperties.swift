//
//  DeviceMotionResultModel+CoreDataProperties.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 26/01/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import CoreData

extension DeviceMotionResultModel {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<DeviceMotionResultModel> {
    return NSFetchRequest<DeviceMotionResultModel>(entityName: "DeviceMotionResultModel")
  }
  
  @NSManaged public var deviceMotion: NSSet?
  @NSManaged public var step: StepModel?
  
}

// MARK: Generated accessors for deviceMotion
extension DeviceMotionResultModel {
  
  @objc(addDeviceMotionObject:)
  @NSManaged public func addToDeviceMotion(_ value: DeviceMotionModel)
  
  @objc(removeDeviceMotionObject:)
  @NSManaged public func removeFromDeviceMotion(_ value: DeviceMotionModel)
  
  @objc(addDeviceMotion:)
  @NSManaged public func addToDeviceMotion(_ values: NSSet)
  
  @objc(removeDeviceMotion:)
  @NSManaged public func removeFromDeviceMotion(_ values: NSSet)
  
}
