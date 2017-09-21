//
//  SmartAssistantHistoryDetailsViewModel.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 24/05/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreData
import Foundation
import RxCoreData
import RxDataSources
import RxSwift
import RxCocoa

// swiftlint:disable force_cast type_name
struct ProcessedSmartAssistantHistoryDetailsViewModel: SmartAssistantHistoryDetailsViewModel {

  var id: Int
  var identifier: String
  var startDate: Date
  var endDate: Date?
  var classificationTask: ClassificationTask<ProcessedData, ProcessedClassificationTaskModel>
  var sending = Variable(false)
}

extension ProcessedSmartAssistantHistoryDetailsViewModel: Equatable { }

extension ProcessedSmartAssistantHistoryDetailsViewModel: IdentifiableType {
  typealias Identity = String

  var identity: Identity { return "\(id)" }
}

extension ProcessedSmartAssistantHistoryDetailsViewModel: Persistable {
  typealias ManagedObject = ProcessedClassificationTaskModel

  static var entityName: String {
    return "ProcessedClassificationTaskModel"
  }

  static var primaryAttributeName: String {
    return "id"
  }

  init(entity: ManagedObject) {
    //swiftlint:disable force_try
    classificationTask = try! entity.map()
    id = classificationTask.id
    identifier = classificationTask.identifier
    startDate = classificationTask.startDate
    endDate = classificationTask.endDate
  }

  func update(_ entity: ManagedObject) {
    entity.identifier = identifier

    do {
      try entity.managedObjectContext?.save()
    } catch let e {
      print(e)
    }
  }

  func send() {
    guard let url = URL(string: "http://192.168.1.77:8080/processedClassificationTask") else {
      return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONSerialization.data(withJSONObject: classificationTask.toJSON(), options: .prettyPrinted)

    print(classificationTask.toJSONString(prettyPrint: true) as Any)

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data, error == nil else { // check for fundamental networking error
        print("error=\(String(describing: error))")
        return
      }

      if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 { // check for http errors
        print("statusCode should be 200, but is \(httpStatus.statusCode)")
        print("response = \(String(describing: response))")
      }

      let responseString = String(data: data, encoding: .utf8)
      print("responseString = \(String(describing: responseString))")
    }
    task.resume()
  }

}
