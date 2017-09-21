//
//  RawData.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 02/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreMotion
import CoreML
import Foundation
import ObjectMapper

class RawData: MotionData {
  var identifier: Int!
  var initialTimestamp: Double!
  var finalTimestamp: Double!
  var motionData: [DeviceMotionData]!
  var samplesUsed: Int!
  var currentActivity: MotionActivity!

  var dataClassification: DataClassification?

  static func handle(
    motionData: [CMDeviceMotion],
    motionActivity: [CMMotionActivity],
    with identifier: Int,
    last: MotionData?
  ) throws -> MotionData {
    guard var initialTimestamp = motionData.first?.timestamp,
      var finalTimestamp = motionData.last?.timestamp else {
        throw "Couldn't process data"
    }

    initialTimestamp = UnixTimeOffset.sharedInstance.unixTimestamp(timestamp: initialTimestamp)
    finalTimestamp = UnixTimeOffset.sharedInstance.unixTimestamp(timestamp: finalTimestamp)

    let currentActivity = computeCurrentActivity(data: motionActivity, lastActivity: last?.currentActivity)

    return RawData(
      identifier: identifier,
      initialTimestamp: initialTimestamp,
      finalTimestamp: finalTimestamp,
      motionData: motionData.map { $0.mapToDeviceMotionData() },
      currentActivity: currentActivity,
      samplesUsed: motionData.count
    )
  }

  init(identifier: Int,
       initialTimestamp: Double,
       finalTimestamp: Double,
       motionData: [DeviceMotionData],
       currentActivity: MotionActivity,
       samplesUsed: Int,
       dataClassification: DataClassification? = nil) {

    self.identifier = identifier
    self.initialTimestamp = initialTimestamp
    self.finalTimestamp = finalTimestamp
    self.motionData = motionData
    self.currentActivity = currentActivity
    self.samplesUsed = samplesUsed
    self.dataClassification = dataClassification
  }

  required init?(map: Map) {

  }

  static func applyStaticClassification(data: MotionData) -> Classification? {
    guard let data = data as? RawData else {
      return nil
    }

    var classification: Classification = .balanced
    fatalError("TODO implement a static classifier for raw data")
    return classification
  }
}

extension RawData {
    public func mapping(map: Map) {
      identifier <- map["identifier"]
      initialTimestamp <- map["initialTimestamp"]
      finalTimestamp <- map["finalTimestamp"]
      motionData <- map ["motionData"]
      currentActivity <- (map["currentActivity"], EnumTransform<MotionActivity>())
      samplesUsed <- map["samplesUsed"]
    }
}

extension RawData {
  func asArray() -> [[Double]] {
    return motionData.map { (element: DeviceMotionData) -> [Double] in
      return [
        element.attitude.w,
        element.attitude.x,
        element.attitude.y,
        element.attitude.z,

        element.gravity.x,
        element.gravity.y,
        element.gravity.z,

        element.rotationRate.x,
        element.rotationRate.y,
        element.rotationRate.z,

        element.userAcceleration.x,
        element.userAcceleration.y,
        element.userAcceleration.z
      ]
    }
  }

  @available(watchOSApplicationExtension 4.0, *)
  func asMLMultiArray() throws -> [MLMultiArray] {
    return try asArray().map { (element) -> MLMultiArray in
      let data = try MLMultiArray(shape: [NSNumber(value: element.count)], dataType: .double)
      element.enumerated().forEach { data[$0.offset] = NSNumber(value: $0.element) }
      return data
    }
//    return try motionData.map { (element: DeviceMotionData) -> MLMultiArray in
//      let data = try MLMultiArray(shape: [26], dataType: .double)
//
//      data[0] = NSNumber(value: element.attitude.w)
//      data[1] = NSNumber(value: element.attitude.x)
//      data[2] = NSNumber(value: element.attitude.y)
//      data[3] = NSNumber(value: element.attitude.z)
//
//      data[4] = NSNumber(value: element.gravity.x)
//      data[5] = NSNumber(value: element.gravity.y)
//      data[6] = NSNumber(value: element.gravity.z)
//
//      data[7] = NSNumber(value: element.rotationRate.x)
//      data[8] = NSNumber(value: element.rotationRate.y)
//      data[9] = NSNumber(value: element.rotationRate.z)
//
//      data[10] = NSNumber(value: element.userAcceleration.x)
//      data[11] = NSNumber(value: element.userAcceleration.y)
//      data[12] = NSNumber(value: element.userAcceleration.z)
//
//      return data
//    }
  }

  func timestamps() -> [Double] {
    return motionData.map { $0.timestamp }
  }
}

extension RawData {
  static var startSmartAssistant: String {
    return "startRawSmartAssistant"
  }

  static var stopSmartAssistant: String {
    return "stopRawSmartAssistant"
  }

  static var resumeSmartAssistant: String {
    return "resumeRawSmartAssistant"
  }

  static var nextDataElement: String {
    return "smartAssistantRawData"
  }

  static var updateSmartAssistantSensivity: String {
    return "updateSmartAssistantRawSensivity"
  }
}
