//
//  CoreDataTransformable.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 04/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreData
import Foundation

protocol CoreDataTransformable {
  func getCoreDataObject(for context: NSManagedObjectContext) -> MergedDataModel?
}
