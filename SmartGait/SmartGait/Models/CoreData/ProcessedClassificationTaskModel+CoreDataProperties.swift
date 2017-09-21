//
//  ProcessedClassificationTaskModel+CoreDataProperties.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 06/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//
//

import Foundation
import CoreData

extension ProcessedClassificationTaskModel {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<ProcessedClassificationTaskModel> {
    return NSFetchRequest<ProcessedClassificationTaskModel>(entityName: "ProcessedClassificationTaskModel")
  }

  @NSManaged public var mergedProcessedData: NSSet?

}

// MARK: Generated accessors for mergedProcessedData
extension ProcessedClassificationTaskModel {

  @objc(addMergedProcessedDataObject:)
  @NSManaged public func addToMergedProcessedData(_ value: ProcessedMergedDataModel)

  @objc(removeMergedProcessedDataObject:)
  @NSManaged public func removeFromMergedProcessedData(_ value: ProcessedMergedDataModel)

  @objc(addMergedProcessedData:)
  @NSManaged public func addToMergedProcessedData(_ values: NSSet)

  @objc(removeMergedProcessedData:)
  @NSManaged public func removeFromMergedProcessedData(_ values: NSSet)

}
