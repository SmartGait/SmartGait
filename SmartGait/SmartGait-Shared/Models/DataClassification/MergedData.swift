//
//  MergedData.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 27/03/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreML
import Foundation
import ObjectMapper

struct MergedData<MData: MotionData>: Mappable {
  var iOSData: MData!
  var watchOSData: MData!

  var dataClassification: DataClassification?
  var classificationSummary: String?
  var currentActivity: String?

  init?(map: Map) { }

  init(iOSData: MData,
       watchOSData: MData,
       dataClassification: DataClassification? = nil,
       classificationSummary: String? = nil,
       currentActivity: String? = nil) {

    self.iOSData = iOSData
    self.watchOSData = watchOSData
    self.dataClassification = dataClassification
    self.classificationSummary = classificationSummary
    self.currentActivity = currentActivity
  }
}

extension MergedData {

  mutating func mapping(map: Map) {
    iOSData <- map["iOSData"]
    watchOSData <- map["watchOSData"]
    dataClassification <- map["dataClassification"]
    classificationSummary <- map["classificationSummary"]
    currentActivity <- map["currentActivity"]
  }
}

extension MergedData: ClassifiableData {
  @available(watchOSApplicationExtension 4.0, *)
  func asMLMultiArray() throws -> [MLMultiArray] {
//    let iOSDataArray = try iOSData.asMLMultiArray()
//    let watchOSDataArray = try watchOSData.asMLMultiArray()
//
//    let iOSTimestamps = iOSData.timestamps()
//    let watchOSTimestamps = watchOSData.timestamps()
//
//    guard iOSDataArray.count != 0 && watchOSDataArray.count != 0 else {
//      throw "One of the arrays is empty"
//    }
//
//    if iOSDataArray.count == watchOSDataArray.count {
//      //FIXME: Update when this change is rollbacked
//      return try zip(iOSData.asMLMultiArray(), watchOSData.asMLMultiArray()).map { (arrays) -> MLMultiArray in
//        let (iOSArray, watchOSArray) = arrays
//        return try MLMultiArray.append(iOSArray, watchOSArray)
//      }
//    }
//    var syncedEntries = [MLMultiArray]()
//
//    for (iOSIndex, iOSTimestamp) in iOSTimestamps.enumerated() {
//      var timestampDiff = abs(iOSTimestamp - watchOSTimestamps[0])
//      var selectedIndex: Int?
//      var usedIndexes = [Int: Bool]()
//
//      for (watchOSIndex, watchOSTimestamp) in watchOSTimestamps.enumerated() {
//        let diff = abs(iOSTimestamp - watchOSTimestamp)
//
//        if diff <= timestampDiff {
//          timestampDiff = diff
//          selectedIndex = watchOSIndex
//        } else {
//          break
//        }
//      }
//      if let index = selectedIndex, usedIndexes[index] == nil {
//        syncedEntries.append(try MLMultiArray.append(iOSDataArray[iOSIndex], watchOSDataArray[index]))
//        usedIndexes[index] = true
//      }
//    }
//    return syncedEntries
    return try asArray().map { (element) -> MLMultiArray in
      let data = try MLMultiArray(shape: [NSNumber(value: element.count)], dataType: .double)
      element.enumerated().forEach { data[$0.offset] = NSNumber(value: $0.element) }
      return data
    }
  }

  func asArray() -> [[Double]] {
    let iOSDataArray = iOSData.asArray()
    let watchOSDataArray = watchOSData.asArray()

    let iOSTimestamps = iOSData.timestamps()
    let watchOSTimestamps = watchOSData.timestamps()

    guard iOSDataArray.count != 0 && watchOSDataArray.count != 0 else {
      return [[]]
    }

    if iOSDataArray.count == watchOSDataArray.count {
      //FIXME: Update when this change is rollbacked
      return zip(iOSData.asArray(), watchOSData.asArray()).map { $0.0 + $0.1 }
    }

    var syncedEntries = [[Double]]()

    for (iOSIndex, iOSTimestamp) in iOSTimestamps.enumerated() {
      var timestampDiff = abs(iOSTimestamp - watchOSTimestamps[0])
      var selectedIndex: Int?

      for (watchOSIndex, watchOSTimestamp) in watchOSTimestamps.enumerated() {
        let diff = abs(iOSTimestamp - watchOSTimestamp)

        if diff <= timestampDiff {
          timestampDiff = diff
          selectedIndex = watchOSIndex
        } else {
          break
        }
      }
      if let index = selectedIndex {
        syncedEntries.append(iOSDataArray[iOSIndex] + watchOSDataArray[index])
      }
    }

    return syncedEntries
  }
}
