//
//  AccelerometerResultModel+CoreDataProperties.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 26/01/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import CoreData

extension AccelerometerResultModel {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<AccelerometerResultModel> {
    return NSFetchRequest<AccelerometerResultModel>(entityName: "AccelerometerResultModel")
  }

  @NSManaged public var accelerometer: NSSet?
  @NSManaged public var step: StepModel?

}

// MARK: Generated accessors for accelerometer
extension AccelerometerResultModel {

  @objc(addAccelerometerObject:)
  @NSManaged public func addToAccelerometer(_ value: AccelerometerModel)

  @objc(removeAccelerometerObject:)
  @NSManaged public func removeFromAccelerometer(_ value: AccelerometerModel)

  @objc(addAccelerometer:)
  @NSManaged public func addToAccelerometer(_ values: NSSet)

  @objc(removeAccelerometer:)
  @NSManaged public func removeFromAccelerometer(_ values: NSSet)

}
