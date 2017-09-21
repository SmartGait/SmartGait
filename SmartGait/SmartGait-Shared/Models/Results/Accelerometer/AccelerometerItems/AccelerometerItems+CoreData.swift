//
//  AccelerometerItems+CoreData.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 03/02/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import CoreData

// MARK: - CoreData
extension AccelerometerItems {
  func getCoreDataObject(for context: NSManagedObjectContext) -> NSSet {
    return Set(items.flatMap { $0.getCoreDataObject(for: context) }) as NSSet
  }
}
