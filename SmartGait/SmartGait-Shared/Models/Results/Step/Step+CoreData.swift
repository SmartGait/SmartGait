//
//  Step+CoreData.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 03/02/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import CoreData

// MARK: - CoreData
extension Step {
  func getCoreDataObject(for context: NSManagedObjectContext) -> StepModel? {
    let model = NSEntityDescription
      .insertNewObject(forEntityName: "StepModel", into: context) as? StepModel

    model?.identifier = identifier
    model?.deviceMotionResult = deviceMotion.getCoreDataObject(for: context)
    model?.accelerometerResult = accelerometer.getCoreDataObject(for: context)

    return model
  }
}
