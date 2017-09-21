//
//  AccelerometerModel+CoreDataProperties.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 26/01/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import CoreData

extension AccelerometerModel {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<AccelerometerModel> {
    return NSFetchRequest<AccelerometerModel>(entityName: "AccelerometerModel")
  }

  @NSManaged public var x: Double
  @NSManaged public var y: Double
  @NSManaged public var z: Double
  @NSManaged public var timestamp: Double
  @NSManaged public var acceloremeterResult: AccelerometerResultModel?

}
