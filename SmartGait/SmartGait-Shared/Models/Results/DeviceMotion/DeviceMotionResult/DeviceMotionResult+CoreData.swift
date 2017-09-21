//
//  DeviceMotionResult+CoreData.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 03/02/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import CoreData

// MARK: - CoreData
extension DeviceMotionResult {
  func getCoreDataObject(for context: NSManagedObjectContext) -> DeviceMotionResultModel? {
    let model = NSEntityDescription
      .insertNewObject(forEntityName: "DeviceMotionResultModel", into: context) as? DeviceMotionResultModel

    model?.identifier = identifier
    model?.startDate = startDate as NSDate
    model?.endDate = endDate as NSDate
    model?.fileURL = fileURL?.absoluteString
    model?.deviceMotion = data?.getCoreDataObject(for: context)

    return model
  }
}
