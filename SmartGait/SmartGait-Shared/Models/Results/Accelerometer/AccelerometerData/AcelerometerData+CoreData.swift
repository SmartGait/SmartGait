//
//  AcelerometerData+CoreData.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 03/02/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import CoreData

// MARK: - CoreData
extension AccelerometerData {
  func getCoreDataObject(for context: NSManagedObjectContext) -> AccelerometerModel? {
    let model = NSEntityDescription
      .insertNewObject(forEntityName: "AccelerometerModel", into: context) as? AccelerometerModel

    model?.x = x
    model?.y = y
    model?.z = z
    model?.timestamp = timestamp

    return model
  }
}
