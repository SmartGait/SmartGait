//
//  RawDataModel+CoreDataProperties.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 06/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//
//

import Foundation
import CoreData

extension RawDataModel {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<RawDataModel> {
    return NSFetchRequest<RawDataModel>(entityName: "RawDataModel")
  }

  @NSManaged public var iOSRawMergedData: RawMergedDataModel?
  @NSManaged public var motionData: NSSet?
  @NSManaged public var watchOSRawMergedData: RawMergedDataModel?

}

// MARK: Generated accessors for motionData
extension RawDataModel {

  @objc(addMotionDataObject:)
  @NSManaged public func addToMotionData(_ value: DeviceMotionModel)

  @objc(removeMotionDataObject:)
  @NSManaged public func removeFromMotionData(_ value: DeviceMotionModel)

  @objc(addMotionData:)
  @NSManaged public func addToMotionData(_ values: NSSet)

  @objc(removeMotionData:)
  @NSManaged public func removeFromMotionData(_ values: NSSet)

}
