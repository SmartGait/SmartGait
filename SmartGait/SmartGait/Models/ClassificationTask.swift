//
//  ClassifyingTask.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 20/05/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreData
import Foundation
import ObjectMapper

struct ClassificationTask<MD: MotionData, CTModel: GenericClassificationTaskModel>: Mappable {
  var id: Int!
  var identifier: String!
  var mergedData: [MergedData<MD>]!
  var startDate: Date!
  var endDate: Date?

  fileprivate var classificationTaskModel: CTModel?

  init(
    id: Int = Constants.sharedInstance.newClassificationTaskID(),
    identifier: String = "Classification Task",
    mergedData: [MergedData<MD>] = [],
    startDate: Date = Date(),
    endDate: Date? = nil
    ) {
    self.id = id
    self.identifier = identifier
    self.mergedData = mergedData
    self.startDate = startDate
  }

}

extension ClassificationTask {
  init?(map: Map) {

  }

  mutating func mapping(map: Map) {
    id <- map["id"]
    identifier <- map["identifier"]
    mergedData <- map["mergedData"]
    startDate <- (map["startDate"], DateTransform())
    endDate <- (map["endDate"], DateTransform())
  }
}

// MARK: - CoreData
extension ClassificationTask {
  func getCoreDataObject(for context: NSManagedObjectContext) throws -> CTModel? {

    let fetchRequest = NSFetchRequest<CTModel>(entityName: "\(CTModel.self)")
    fetchRequest.predicate = NSPredicate(format: "id = %d", id)

    let results = try context.fetch(fetchRequest)

    print(results.count)
    guard results.count == 0 else {
      return results.first
    }

    return CTModel.getNewObject(id: id,
                                identifier: identifier,
                                startDate: startDate,
                                endDate: endDate,
                                mergedData: mergedData,
                                withContext: context)
  }

  fileprivate mutating func updateCoreDataObject(for context: NSManagedObjectContext,
                                                 update: (CTModel) throws -> Void) throws {
    if classificationTaskModel == nil {
      classificationTaskModel = try getCoreDataObject(for: context)
    }

    guard let model = classificationTaskModel else {
      throw "Couldn't fetch Classification Task Model"
    }

    try update(model)

    try context.save()
  }

  mutating func updateMergedData(for context: NSManagedObjectContext) throws {
    let mergedDataTemp = mergedData
    try updateCoreDataObject(for: context) { (model) in
      guard
        let mergedObjects = mergedDataTemp?.flatMap ({ $0.getCoreDataObject(for: context) }),
        let updatedMergedData = model.mergedData?.addingObjects(from: mergedObjects) else {
          throw "Couldn't add new objects"
      }

      model.mergedData = NSSet(set: updatedMergedData)
    }
  }

  mutating func updateEndDate(for context: NSManagedObjectContext) throws {
    let endDateTemp = self.endDate
    try updateCoreDataObject(for: context) { (model) in
      guard let endDate = endDateTemp else {
        return
      }

      model.endDate = endDate as NSDate
    }
  }
}
