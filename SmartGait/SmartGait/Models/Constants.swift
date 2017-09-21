//
//  Constants.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 02/05/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation

fileprivate enum IDKey: String {
  case task
  case classificationTask
}

//swiftlint:disable type_name
fileprivate struct ID {
  var value: Int

  mutating func increment() {
    value += 1
  }
}

class Constants {
  static var sharedInstance = Constants()

  let neuralNetworksManager = NeuralNetworksManager.sharedInstance
  let standarizeDataManager = StandarizeDataManager.sharedInstance

  private var task: ID
  private var classificationTask: ID

  private let defaults: UserDefaults

  private init(defaults: UserDefaults = UserDefaults.standard) {
    self.defaults = defaults
    task = ID(value: Constants.getCurrentId(forKey: .task))
    classificationTask = ID(value: Constants.getCurrentId(forKey: .classificationTask))
  }

  private static func getCurrentId(forKey key: IDKey) -> Int {
    let defaults = UserDefaults.standard
    return defaults.integer(forKey: key.rawValue)
  }

  func saveCurrentIds() {
    let defaults = UserDefaults.standard
    defaults.set(task.value, forKey: IDKey.task.rawValue)
    defaults.set(classificationTask.value, forKey: IDKey.classificationTask.rawValue)
  }

  func newTaskID() -> Int {
    task.increment()
    defaults.set(task.value, forKey: IDKey.task.rawValue)
    return task.value
  }

  func currentTaskID() -> Int {
    return task.value
  }

  func newClassificationTaskID() -> Int {
    classificationTask.increment()
    defaults.set(classificationTask.value, forKey: IDKey.classificationTask.rawValue)
    return classificationTask.value
  }

  func currentClassificationTaskID() -> Int {
    return classificationTask.value
  }
}
