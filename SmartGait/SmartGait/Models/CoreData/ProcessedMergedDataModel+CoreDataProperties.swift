//
//  ProcessedMergedDataModel+CoreDataProperties.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 06/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//
//

import Foundation
import CoreData

extension ProcessedMergedDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProcessedMergedDataModel> {
        return NSFetchRequest<ProcessedMergedDataModel>(entityName: "ProcessedMergedDataModel")
    }

    @NSManaged public var processedClassificationTask: ProcessedClassificationTaskModel?
    @NSManaged public var iOSProcessedData: ProcessedDataModel?
    @NSManaged public var watchOSProcessedData: ProcessedDataModel?

}
