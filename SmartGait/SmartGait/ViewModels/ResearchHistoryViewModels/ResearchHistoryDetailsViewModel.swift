//
//  Task+IdentifiableType.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 18/03/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import CoreData
import RxDataSources
import RxCoreData

// swiftlint:disable force_cast
func == (lhs: ResearchHistoryDetailsViewModel, rhs: ResearchHistoryDetailsViewModel) -> Bool {
  return lhs.id == rhs.id
}

struct ResearchHistoryDetailsViewModel {
  var id: Int
  var identifier: String
  let startDate: Date
  let endDate: Date
}

extension ResearchHistoryDetailsViewModel: Equatable { }

extension ResearchHistoryDetailsViewModel: IdentifiableType {
  typealias Identity = String

  var identity: Identity { return "\(id)" }
}

extension ResearchHistoryDetailsViewModel: Persistable {
  typealias ManagedObject = NSManagedObject

  static var entityName: String {
    return "TaskModel"
  }

  static var primaryAttributeName: String {
    return "id"
  }

  init(entity: ManagedObject) {
    id = entity.value(forKey: "id") as! Int
    identifier = entity.value(forKey: "identifier") as! String
    startDate = entity.value(forKey: "startDate") as! Date
    endDate = entity.value(forKey: "endDate") as! Date
  }

  func update(_ entity: ManagedObject) {
    entity.setValue(identifier, forKey: "identifier")
    entity.setValue(startDate, forKey: "startDate")
    entity.setValue(endDate, forKey: "endDate")

    do {
      try entity.managedObjectContext?.save()
    } catch let e {
      print(e)
    }
  }
}
