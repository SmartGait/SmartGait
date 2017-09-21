//
//  ResultModel+CoreDataProperties.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 26/01/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import CoreData

extension ResultModel {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<ResultModel> {
    return NSFetchRequest<ResultModel>(entityName: "ResultModel")
  }
  
  @NSManaged public var endDate: NSDate?
  @NSManaged public var fileURL: String?
  @NSManaged public var identifier: String?
  @NSManaged public var startDate: NSDate?
  
}
