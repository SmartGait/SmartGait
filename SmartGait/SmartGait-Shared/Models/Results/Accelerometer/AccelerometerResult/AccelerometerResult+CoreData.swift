//
//  AccelerometerResult+CoreData.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 03/02/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import CoreData

// MARK: - CoreData
extension AccelerometerResult {
  func getCoreDataObject(for context: NSManagedObjectContext) -> AccelerometerResultModel? {
    let model = NSEntityDescription
      .insertNewObject(forEntityName: "AccelerometerResultModel", into: context) as? AccelerometerResultModel

    model?.identifier = identifier
    model?.startDate = startDate as NSDate
    model?.endDate = endDate as NSDate
    model?.fileURL = fileURL?.absoluteString
    model?.accelerometer = data?.getCoreDataObject(for: context)

    return model
  }
}
