//
//  SmartAssistantHistoryDetailsViewModel.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 14/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import RxCoreData
import RxCoreData
import RxDataSources
import RxSwift
import RxCocoa

func == <ViewModel: SmartAssistantHistoryDetailsViewModel>(lhs: ViewModel, rhs: ViewModel) -> Bool {
  return lhs.id == rhs.id
}

protocol SmartAssistantHistoryDetailsViewModel: Equatable, IdentifiableType, Persistable {
  associatedtype Data: MotionData
  associatedtype TaskModel: GenericClassificationTaskModel

  var id: Int { get set }
  var identifier: String { get set }
  var startDate: Date { get set }
  var endDate: Date? { get set }
  var classificationTask: ClassificationTask<Data, TaskModel> { get set }

  var sending: Variable<Bool> { get set }

  func send()
}

extension SmartAssistantHistoryDetailsViewModel {
  var identity: String { return "\(id)" }
}

extension SmartAssistantHistoryDetailsViewModel {
  static var primaryAttributeName: String {
    return "id"
  }
}
