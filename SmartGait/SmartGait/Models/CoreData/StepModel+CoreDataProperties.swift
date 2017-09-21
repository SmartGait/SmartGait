//
//  StepModel+CoreDataProperties.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 26/01/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import CoreData

extension StepModel {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<StepModel> {
    return NSFetchRequest<StepModel>(entityName: "StepModel")
  }
  
  @NSManaged public var identifier: String?
  @NSManaged public var accelerometerResult: AccelerometerResultModel?
  @NSManaged public var deviceMotionResult: DeviceMotionResultModel?
  @NSManaged public var task: TaskModel?
  
}
