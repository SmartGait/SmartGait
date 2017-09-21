//
//  HistoryViewModels.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 21/04/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreData
import Foundation
import RxCocoa
import RxCoreData
import RxSwift

typealias ResearchHistoryViewModelConstructor = () throws -> Observable<[ResearchHistoryDetailsViewModel]>
struct ResearchHistoryViewModel {
  let viewModels: Observable<[ResearchHistoryDetailsViewModel]>

  init(viewModelsConstructor: ResearchHistoryViewModelConstructor = StaticFunctions.defaultViewModels()) throws {
    self.viewModels = try viewModelsConstructor()
  }
}

fileprivate typealias StaticFunctions = ResearchHistoryDetailsViewModel
extension StaticFunctions {
  static func defaultViewModels() -> ResearchHistoryViewModelConstructor {
    return {
      return try getContext().rx.entities(ResearchHistoryDetailsViewModel.self,
                                          sortDescriptors: [NSSortDescriptor(key: "startDate", ascending: false)])
    }
  }

  private static func getContext() throws -> NSManagedObjectContext {
    return CoreDataManager.sharedInstance.viewContext
  }
}
