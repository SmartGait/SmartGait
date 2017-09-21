//
//  Task+CoreData.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 03/02/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import CoreData

// MARK: CoreData
extension Task {
  func getCoreDataObject(for context: NSManagedObjectContext) -> TaskModel? {
    let model = NSEntityDescription
      .insertNewObject(forEntityName: "TaskModel", into: context) as? TaskModel

    model?.id = Int64(Constants.sharedInstance.newTaskID())
    model?.identifier = identifier
    model?.startDate = startDate as NSDate
    model?.endDate = endDate as NSDate
    model?.steps = Set(steps.flatMap { $0.getCoreDataObject(for: context) }) as NSSet

    return model
  }
}
