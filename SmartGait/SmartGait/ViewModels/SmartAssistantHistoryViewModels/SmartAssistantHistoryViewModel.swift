//
//  SmartAssistantHistoryViewModel.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 24/05/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreData
import Foundation
import RxCocoa
import RxCoreData
import RxSwift

struct SmartAssistantHistoryViewModel<ViewModel: SmartAssistantHistoryDetailsViewModel> {
  let viewModels: Observable<[ViewModel]>

  init(viewModelsConstructor: () throws -> Observable<[ViewModel]> = SmartAssistantHistoryViewModel
    .defaultViewModels(forType: ViewModel.self)) throws {

    self.viewModels = try viewModelsConstructor()
  }
}

extension SmartAssistantHistoryViewModel {
  static func defaultViewModels<T: SmartAssistantHistoryDetailsViewModel>(
    forType type: T.Type) -> () throws -> Observable<[T]> {
    return {
      return try getContext().rx.entities(type.self,
                                          fetchLimit: 1,
                                          sortDescriptors: [NSSortDescriptor(key: "startDate", ascending: false)])
    }
  }

 static func getContext() throws -> NSManagedObjectContext {
    return CoreDataManager.sharedInstance.backgroundContext
  }
}
