//
//  ProcessedDataModel+CoreDataProperties.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 06/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//
//

import Foundation
import CoreData

extension ProcessedDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProcessedDataModel> {
        return NSFetchRequest<ProcessedDataModel>(entityName: "ProcessedDataModel")
    }

    @NSManaged public var averageGravityX: Double
    @NSManaged public var averageGravityY: Double
    @NSManaged public var averageGravityZ: Double
    @NSManaged public var diffAverageGravityX: Double
    @NSManaged public var diffAverageGravityY: Double
    @NSManaged public var diffAverageGravityZ: Double
    @NSManaged public var diffMaxMinX: Double
    @NSManaged public var diffMaxMinY: Double
    @NSManaged public var diffMaxMinZ: Double
    @NSManaged public var maxX: Double
    @NSManaged public var maxY: Double
    @NSManaged public var maxZ: Double
    @NSManaged public var minX: Double
    @NSManaged public var minY: Double
    @NSManaged public var minZ: Double
    @NSManaged public var rmsX: Double
    @NSManaged public var rmsY: Double
    @NSManaged public var rmsZ: Double
    @NSManaged public var standardDeviationX: Double
    @NSManaged public var standardDeviationY: Double
    @NSManaged public var standardDeviationZ: Double
    @NSManaged public var sumOfDifferencesX: Double
    @NSManaged public var sumOfDifferencesY: Double
    @NSManaged public var sumOfDifferencesZ: Double
    @NSManaged public var sumOfMagnitudeDiffs: Double
    @NSManaged public var iOSProcessedMergedData: ProcessedMergedDataModel?
    @NSManaged public var watchOSProcessedMergedData: ProcessedMergedDataModel?

}
