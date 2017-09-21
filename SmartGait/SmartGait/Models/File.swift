//
//  File.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 02/05/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation

enum File: String {
  case iOSRawRest = "merged-all-iOS-rest"
  case iOSRawWalking = "merged-all-iOS-walking"

  case watchOSRawRest = "merged-all-watchOS-rest"
  case watchOSRawWalking = "merged-all-watchOS-walking"

  case iOSProcessedRest = "merged-all-iOS-processed-rest"
  case watchOSProcessedRest = "merged-all-watchOS-processed-rest"

  case iOSProcessedWalking = "merged-all-iOS-processed-walking"
  case watchOSProcessedWalking = "merged-all-watchOS-processed-walking"

  case iOSWatchOSRawMergedRest = "merged-all-iOS-watchOS-rest"
  case iOSWatchOSRawMergedWalking = "merged-all-iOS-watchOS-walking"
  case iOSWatchOSRawMergedWalkingRest = "merged-all-iOS-watchOS-walking-rest"

  case iOSWatchOSProcessedMergedRest = "merged-all-iOS-watchOS-processed-rest"
  case iOSWatchOSProcessedMergedWalking = "merged-all-iOS-watchOS-processed-walking"
  case iOSWatchOSProcessedMergedWalkingRest = "merged-all-iOS-watchOS-processed-walking-rest"

  func neuralNetPath() throws-> String {
    return try path(forFile: rawValue, ofType: "net")
  }

  func standarizationParametersPath() throws-> String {
    return try path(forFile: rawValue, ofType: "json")
  }

  private func path(forFile file: String, ofType type: String) throws -> String {
    guard let path = Bundle.main.path(forResource: file, ofType: type) else {
      throw "Couldn't find path for file \(self.rawValue).\(type)"
    }
    return path
  }
}
