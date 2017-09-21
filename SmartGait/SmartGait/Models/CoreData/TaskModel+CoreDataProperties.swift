//
//  TaskModel+CoreDataProperties.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 23/05/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import CoreData

extension TaskModel {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskModel> {
    return NSFetchRequest<TaskModel>(entityName: "TaskModel")
  }
  
  @NSManaged public var endDate: NSDate?
  @NSManaged public var identifier: String?
  @NSManaged public var startDate: NSDate?
  @NSManaged public var id: Int64
  @NSManaged public var steps: NSSet?
  
}

// MARK: Generated accessors for steps
extension TaskModel {
  
  @objc(addStepsObject:)
  @NSManaged public func addToSteps(_ value: StepModel)
  
  @objc(removeStepsObject:)
  @NSManaged public func removeFromSteps(_ value: StepModel)
  
  @objc(addSteps:)
  @NSManaged public func addToSteps(_ values: NSSet)
  
  @objc(removeSteps:)
  @NSManaged public func removeFromSteps(_ values: NSSet)
  
}
