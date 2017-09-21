//
//  RawSmartAssistantHistoryDetailsViewModel.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 14/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreData
import Foundation
import RxCocoa
import RxCoreData
import RxDataSources
import RxSwift

// swiftlint:disable force_cast type_name
struct RawSmartAssistantHistoryDetailsViewModel: SmartAssistantHistoryDetailsViewModel {
  var id: Int
  var identifier: String
  var startDate: Date
  var endDate: Date?
  var classificationTask: ClassificationTask<RawData, RawClassificationTaskModel>
  var sending = Variable(false)
}

extension RawSmartAssistantHistoryDetailsViewModel: Persistable {
  typealias ManagedObject = RawClassificationTaskModel

  static var entityName: String {
    return "RawClassificationTaskModel"
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
    DispatchQueue.global().async {
      self.sending.value = true
      guard let url = URL(string: "http://89.114.140.115:8080/rawClassificationTask") else {
        self.sending.value = false
        return
      }
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      request.httpBody = try? JSONSerialization.data(withJSONObject: self.classificationTask.toJSON())

      print("Will send")

      let task = URLSession.shared.dataTask(with: request) { data, response, error in
        self.sending.value = false
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
}
