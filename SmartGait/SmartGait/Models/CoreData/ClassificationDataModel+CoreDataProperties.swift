//
//  ClassificationDataModel+CoreDataProperties.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 06/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//
//
import Foundation
import CoreData

extension ClassificationDataModel {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<ClassificationDataModel> {
    return NSFetchRequest<ClassificationDataModel>(entityName: "ClassificationDataModel")
  }

  @NSManaged public var currentActivity: String?
  @NSManaged public var dataClassification: String?
  @NSManaged public var finalTimestamp: Double
  @NSManaged public var identifier: Int64
  @NSManaged public var initialTimestamp: Double
  @NSManaged public var samplesUsed: Int16

}
