//
//  RawClassificationTaskModel+CoreDataProperties.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 06/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//
//

import Foundation
import CoreData

extension RawClassificationTaskModel {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<RawClassificationTaskModel> {
    return NSFetchRequest<RawClassificationTaskModel>(entityName: "RawClassificationTaskModel")
  }

  @NSManaged public var mergedRawData: NSSet?

}

// MARK: Generated accessors for mergedRawData
extension RawClassificationTaskModel {

  @objc(addMergedRawDataObject:)
  @NSManaged public func addToMergedRawData(_ value: RawMergedDataModel)
  
  @objc(removeMergedRawDataObject:)
  @NSManaged public func removeFromMergedRawData(_ value: RawMergedDataModel)

  @objc(addMergedRawData:)
  @NSManaged public func addToMergedRawData(_ values: NSSet)

  @objc(removeMergedRawData:)
  @NSManaged public func removeFromMergedRawData(_ values: NSSet)

}
