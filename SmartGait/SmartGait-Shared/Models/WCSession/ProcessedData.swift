//
//  ProcessedDeviceMotionData.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 14/03/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreMotion
import CoreML
import Foundation
import ObjectMapper

//swiftlint:disable large_tuple
class ProcessedData: NSObject, MotionData {
  var identifier: Int!
  var initialTimestamp: Double!
  var finalTimestamp: Double!

  var max: ThreeDVector!
  var min: ThreeDVector!
  var diffMaxMin: ThreeDVector!
  var averageGravity: ThreeDVector!
  var diffAverageGravity: ThreeDVector!
  var standardDeviation: ThreeDVector!
  var rms: ThreeDVector!
  var sumOfDifferences: ThreeDVector!
  var sumOfMagnitudeDiffs: Double!
  var currentActivity: MotionActivity!
  var samplesUsed: Int!

  var dataClassification: DataClassification?

  init(identifier: Int,
       initialTimestamp: Double,
       finalTimestamp: Double,
       max: ThreeDVector,
       min: ThreeDVector,
       diffMaxMin: ThreeDVector,
       averageGravity: ThreeDVector,
       diffAverageGravity: ThreeDVector,
       standardDeviation: ThreeDVector,
       rms: ThreeDVector,
       sumOfDifferences: ThreeDVector,
       sumOfMagnitudeDiffs: Double,
       currentActivity: MotionActivity,
       samplesUsed: Int,
       dataClassification: DataClassification? = nil) {

    self.identifier = identifier
    self.initialTimestamp = initialTimestamp
    self.finalTimestamp = finalTimestamp
    self.max = max
    self.min = min
    self.diffMaxMin = diffMaxMin
    self.averageGravity = averageGravity
    self.diffAverageGravity = diffAverageGravity
    self.standardDeviation = standardDeviation
    self.rms = rms
    self.sumOfDifferences = sumOfDifferences
    self.sumOfMagnitudeDiffs = sumOfMagnitudeDiffs
    self.currentActivity = currentActivity
    self.samplesUsed = samplesUsed
    self.dataClassification = dataClassification
  }

  required init?(map: Map) {

  }

  static func applyStaticClassification(data: MotionData) -> Classification? {
    guard let data = data as? ProcessedData else {
      return nil
    }

    var classification: Classification = .balanced
    if abs(data.diffAverageGravity.x) >= 0.10 ||
      abs(data.diffAverageGravity.y) >= 0.10 ||
      abs(data.diffAverageGravity.z) >= 0.10 {
      classification = .imbalanced
    }
    return classification
  }
}

extension ProcessedData {
  static var startSmartAssistant: String {
    return "startProcessedSmartAssistant"
  }

  static var stopSmartAssistant: String {
    return "stopProcessedSmartAssistant"
  }

  static var resumeSmartAssistant: String {
    return "resumeProcessedSmartAssistant"
  }

  static var nextDataElement: String {
    return "smartAssistantProcessedData"
  }

  static var updateSmartAssistantSensivity: String {
    fatalError("Implement sensitivity is not implemented on processed data")
  }
}

extension ProcessedData {
  @available(watchOSApplicationExtension 4.0, *)
  func asMLMultiArray() -> [MLMultiArray] {
    fatalError("todo")
  }

  func asArray() -> [[Double]] {
    return [
      [
        averageGravity.x,
        max.x,
        min.x,
        diffMaxMin.x,
        diffAverageGravity.x,
        standardDeviation.x,
        rms.x,
        sumOfDifferences.x,

        averageGravity.y,
        max.y,
        min.y,
        diffMaxMin.y,
        diffAverageGravity.y,
        standardDeviation.y,
        rms.y,
        sumOfDifferences.y,

        averageGravity.z,
        max.z,
        min.z,
        diffMaxMin.z,
        diffAverageGravity.z,
        standardDeviation.z,
        rms.z,
        sumOfDifferences.z,

        sumOfMagnitudeDiffs
      ]
    ]
  }

  func timestamps() -> [Double] {
    return [initialTimestamp]
  }
}

extension ProcessedData {
  public func mapping(map: Map) {
    identifier <- map["identifier"]
    initialTimestamp <- map["initialTimestamp"]
    finalTimestamp <- map["finalTimestamp"]

    max <- map["max"]
    min <- map["min"]
    diffMaxMin <- map["diffMaxMin"]
    averageGravity <- map["averageGravity"]
    diffAverageGravity <- map["diffAverageGravity"]
    standardDeviation <- map["standardDeviation"]
    rms <- map["rms"]
    sumOfDifferences <- map["sumOfDifferences"]
    sumOfMagnitudeDiffs <- map["sumOfMagnitudeDiffs"]
    currentActivity <- (map["currentActivity"], EnumTransform<MotionActivity>())
    samplesUsed <- map["samplesUsed"]
  }

  static func handle(
    motionData: [CMDeviceMotion],
    motionActivity: [CMMotionActivity],
    with identifier: Int,
    last: MotionData?
    ) throws -> MotionData {
    guard let initialTimestamp = motionData.first?.timestamp,
      let finalTimestamp = motionData.last?.timestamp else {
        throw "Couldn't process data"
    }

    let last = last as? ProcessedData

    let max = calculateMax(data: motionData)
    let min = calculateMin(data: motionData)
    let diffMaxMin = calculateDiffMaxMin(max: max, min: min)
    let average = calculateAveragePerAxis(data: motionData)
    let diffAverage = calculateDiffAverage(newDataAverage: average, lastData: last)
    let std = calculateStandardDeviation(data: motionData, average: average)
    let rms = calculateRMS(data: motionData)
    let sumOfDifferences = calculateSumOfDiffsPerAxis(data: motionData)
    let sumOfMagnitudeDiffs = calculateSumOfMagnitudeDiffs(data: motionData)

    let currentActivity = computeCurrentActivity(data: motionActivity, lastActivity: last?.currentActivity)
    print(currentActivity)

    return ProcessedData(identifier: identifier,
                         initialTimestamp: UnixTimeOffset.sharedInstance.unixTimestamp(timestamp: initialTimestamp),
                         finalTimestamp: UnixTimeOffset.sharedInstance.unixTimestamp(timestamp: finalTimestamp),
                         max: max,
                         min: min,
                         diffMaxMin: diffMaxMin,
                         averageGravity: average,
                         diffAverageGravity:  diffAverage,
                         standardDeviation: std,
                         rms: rms,
                         sumOfDifferences: sumOfDifferences,
                         sumOfMagnitudeDiffs: sumOfMagnitudeDiffs,
                         currentActivity: currentActivity,
                         samplesUsed: motionData.count)
  }
}

extension ProcessedData {
  static func calculateMax(data: [CMDeviceMotion]) -> ThreeDVector {
    guard let first = data.first else {
      return ThreeDVector(x: 0, y: 0, z: 0)
    }

    let initialValue = ThreeDVector(x: first.gravity.x, y: first.gravity.y, z: first.gravity.z)

    return data.reduce(initialValue) { (res, deviceMotion) -> (ThreeDVector) in
      return ThreeDVector(x: deviceMotion.gravity.x > res.x ? deviceMotion.gravity.x : res.x,
                          y: deviceMotion.gravity.y > res.y ? deviceMotion.gravity.y : res.y,
                          z: deviceMotion.gravity.z > res.z ? deviceMotion.gravity.z : res.z)
    }
  }

  static func calculateMin(data: [CMDeviceMotion]) -> ThreeDVector {
    guard let first = data.first else {
      return ThreeDVector(x: 0, y: 0, z: 0)
    }

    let initialValue = ThreeDVector(x: first.gravity.x, y: first.gravity.y, z: first.gravity.z)

    return data.reduce(initialValue) { (res, deviceMotion) -> (ThreeDVector) in
      return ThreeDVector(x: deviceMotion.gravity.x < res.x ? deviceMotion.gravity.x : res.x,
                          y: deviceMotion.gravity.y < res.y ? deviceMotion.gravity.y : res.y,
                          z: deviceMotion.gravity.z < res.z ? deviceMotion.gravity.z : res.z)
    }
  }

  static func calculateDiffMaxMin(max: ThreeDVector, min: ThreeDVector) -> ThreeDVector {
    return ThreeDVector(x: max.x - min.x, y: max.y - min.y, z: max.z - min.z)
  }

  static func calculateSumOfDiffsPerAxis(data: [CMDeviceMotion]) -> ThreeDVector {
    guard let first = data.first else {
      return ThreeDVector(x: 0, y: 0, z: 0)
    }

    let initialValue = (x: 0.0, y: 0.0, z: 0.0, last: first)
    let result = data
      .reduce(initialValue) { (res, deviceMotion) -> ((x: Double, y: Double, z: Double, last: CMDeviceMotion)) in
        return (x: res.x + res.last.gravity.x - deviceMotion.gravity.x,
                y: res.y + res.last.gravity.y - deviceMotion.gravity.y,
                res.z + res.last.gravity.z - deviceMotion.gravity.z,
                last: deviceMotion)
    }

    return ThreeDVector(x: result.x, y: result.y, z: result.z)
  }

  static func calculateAveragePerAxis(data: [CMDeviceMotion]) -> ThreeDVector {
    let result = data.reduce(ThreeDVector(x: 0.0, y: 0.0, z: 0.0)) { (res, deviceMotion) -> ThreeDVector in
      return ThreeDVector(x: res.x + deviceMotion.gravity.x,
                          y: res.y + deviceMotion.gravity.y,
                          z: res.z + deviceMotion.gravity.z)
    }

    let count = Double(data.count)

    return ThreeDVector(x: result.x / count,
                        y: result.y / count,
                        z: result.z / count)
  }

  static func calculateDiffAverage(newDataAverage: ThreeDVector,
                                   lastData: ProcessedData?) -> ThreeDVector {

    guard let lastData = lastData else {
      return ThreeDVector(x: -newDataAverage.x, y: -newDataAverage.y, z: -newDataAverage.z)
    }

    return ThreeDVector(x: lastData.averageGravity.x - newDataAverage.x,
                        y: lastData.averageGravity.y - newDataAverage.y,
                        z: lastData.averageGravity.z - newDataAverage.z)
  }

  static func calculateStandardDeviation(data: [CMDeviceMotion], average: ThreeDVector) -> ThreeDVector {
    let result = data.reduce((x: 0.0, y: 0.0, z: 0.0)) { (res, deviceMotion) -> ((x: Double, y: Double, z: Double)) in
      return (x: res.x + pow(deviceMotion.gravity.x - average.x, 2),
              y: res.y + pow(deviceMotion.gravity.y - average.y, 2),
              z: res.z + pow(deviceMotion.gravity.z - average.z, 2))
    }

    let count = Double(data.count)

    return ThreeDVector(x: sqrt(result.x / count),
                        y: sqrt(result.y / count),
                        z: sqrt(result.z / count))
  }

  static func calculateRMS(data: [CMDeviceMotion]) -> ThreeDVector {
    let result = data.reduce(ThreeDVector(x: 0, y: 0, z: 0)) { (res, deviceMotion) -> (ThreeDVector) in
      return ThreeDVector(x: res.x + pow(deviceMotion.gravity.x, 2),
                          y: res.y + pow(deviceMotion.gravity.y, 2),
                          z: res.z + pow(deviceMotion.gravity.z, 2))
    }

    let count = Double(data.count)

    return ThreeDVector(x: sqrt(result.x / count),
                        y: sqrt(result.y / count),
                        z: sqrt(result.z / count))
  }

  static func calculateSumOfMagnitudeDiffs(data: [CMDeviceMotion]) -> Double {
    guard let first = data.first else {
      return 0 // should throw
    }

    let initialResult = sqrt(pow(first.gravity.x, 2) + pow(first.gravity.y, 2) + pow(first.gravity.z, 2))

    return data.reduce((sum: 0.0, last: initialResult)) { (res, motionData) -> ((sum: Double, last: Double)) in
      let magnitude = sqrt(pow(motionData.gravity.x, 2)
        + pow(motionData.gravity.y, 2)
        + pow(motionData.gravity.z, 2))
      return (sum: res.sum + magnitude - res.last, last: magnitude)
      }.sum
  }
}
