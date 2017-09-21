//
//  ClassificationTaskModel+Generic.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 05/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreData
import Foundation

func autocast<T>(_ some: Any) -> T? {
  return some as? T
}

//swiftlint:disable function_parameter_count
protocol GenericClassificationTaskModel: NSFetchRequestResult {
  var mergedData: NSSet? { get set }
  var endDate: NSDate? { get set }
  var id: Int64 { get set }
  var identifier: String? { get set }
  var startDate: NSDate? { get set }

  static func getNewObject<MData>(id: Int,
                                  identifier: String,
                                  startDate: Date,
                                  endDate: Date?,
                                  mergedData: [MergedData<MData>],
                                  withContext context: NSManagedObjectContext) -> Self?
}

extension RawClassificationTaskModel: GenericClassificationTaskModel {
  var mergedData: NSSet? {
    get {
      return mergedRawData
    }
    set {
      mergedRawData = newValue
    }
  }

  static func getNewObject<MData>(id: Int,
                                  identifier: String,
                                  startDate: Date,
                                  endDate: Date?,
                                  mergedData: [MergedData<MData>],
                                  withContext context: NSManagedObjectContext)
    -> Self? where MData : MotionData {

      let model = NSEntityDescription.insertNewObject(
        forEntityName: "RawClassificationTaskModel", into: context) as? RawClassificationTaskModel

      model?.id = Int64(id)
      model?.identifier = identifier
      model?.startDate = startDate as NSDate
      model?.endDate = endDate as NSDate?

      model?.mergedData = Set(mergedData.flatMap { $0.getCoreDataObject(for: context) }) as NSSet
      return autocast(model as Any)
  }
}

extension ProcessedClassificationTaskModel: GenericClassificationTaskModel {
  var mergedData: NSSet? {
    get {
      return mergedProcessedData
    }
    set {
      mergedProcessedData = newValue
    }
  }

  static func getNewObject<MData>(id: Int,
                                  identifier: String,
                                  startDate: Date,
                                  endDate: Date?,
                                  mergedData: [MergedData<MData>],
                                  withContext context: NSManagedObjectContext)
    -> Self? where MData : MotionData {
      let model = NSEntityDescription.insertNewObject(
        forEntityName: "ProcessedClassificationTaskModel", into: context) as? ProcessedClassificationTaskModel

      model?.id = Int64(id)
      model?.identifier = identifier
      model?.startDate = startDate as NSDate
      model?.endDate = endDate as NSDate?

      model?.mergedData = Set(mergedData.flatMap { $0.getCoreDataObject(for: context) }) as NSSet
      return autocast(model as Any)
  }
}
