//
//  MergedData+CoreData.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 04/05/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreData
import Foundation

// MARK: CoreDataww

extension MergedData: CoreDataTransformable {
  func getCoreDataObject(for context: NSManagedObjectContext) -> MergedDataModel? {
    switch MData.self {
    case is ProcessedData.Type:
      return (self as Any as? MergedData<ProcessedData>)?.getCoreDataObject(for: context)
    case is RawData.Type:
      return (self as Any as? MergedData<RawData>)?.getCoreDataObject(for: context)
    default:
      fatalError("MergeData: Not implemented")
    }
  }
}

extension MergedData where MData == ProcessedData {
  func getCoreDataObject(for context: NSManagedObjectContext) -> ProcessedMergedDataModel? {
    let model = NSEntityDescription
      .insertNewObject(forEntityName: "ProcessedMergedDataModel", into: context) as? ProcessedMergedDataModel

    guard let iOSData = iOSData.getCoreDataObject(for: context) as? ProcessedDataModel,
      let watchOSData = watchOSData.getCoreDataObject(for: context) as? ProcessedDataModel else {
        fatalError("Couldn't not cast ProcessedDataModel")
        return nil
    }

    model?.iOSProcessedData = iOSData
    model?.watchOSProcessedData = watchOSData
    model?.dataClassification = dataClassification?.classification.rawValue
    model?.summary = classificationSummary
    model?.currentActivity = currentActivity

    return model
  }
}

extension MergedData where MData == RawData {
  func getCoreDataObject(for context: NSManagedObjectContext) -> RawMergedDataModel? {
    let model = NSEntityDescription
      .insertNewObject(forEntityName: "RawMergedDataModel", into: context) as? RawMergedDataModel

    guard let iOSData = iOSData.getCoreDataObject(for: context) as? RawDataModel,
      let watchOSData = watchOSData.getCoreDataObject(for: context) as? RawDataModel else {
        fatalError("Couldn't not cast RawDataModel")
        return nil
    }

    model?.iOSRawData = iOSData
    model?.watchOSRawData = watchOSData
    model?.dataClassification = dataClassification?.classification.rawValue
    model?.summary = classificationSummary
    model?.currentActivity = currentActivity

    return model
  }
}
