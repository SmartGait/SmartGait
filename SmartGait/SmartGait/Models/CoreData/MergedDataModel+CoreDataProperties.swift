//
//  MergedDataModel+CoreDataProperties.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 06/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//
//

import Foundation
import CoreData

extension MergedDataModel {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<MergedDataModel> {
    return NSFetchRequest<MergedDataModel>(entityName: "MergedDataModel")
  }

  @NSManaged public var currentActivity: String?
  @NSManaged public var dataClassification: String?
  @NSManaged public var summary: String?

}
