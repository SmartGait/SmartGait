//
//  StandarizationManager.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 01/05/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation

struct StandarizeDataManager {
  static let sharedInstance: StandarizeDataManager? = StandarizeDataManager()

  let iOSRawRest: [StandarizationParameters]
  let iOSRawWalking: [StandarizationParameters]

  let watchOSRawRest: [StandarizationParameters]
  let watchOSRawWalking: [StandarizationParameters]

  let iOSProcessedRest: [StandarizationParameters]
  let iOSProcessedWalking: [StandarizationParameters]

  let watchOSProcessedRest: [StandarizationParameters]
  let watchOSProcessedWalking: [StandarizationParameters]

  let bothOSRawRest: [StandarizationParameters]
  let bothOSRawWalking: [StandarizationParameters]
  let bothOSRawWalkingRest: [StandarizationParameters]

  let bothOSProcessedRest: [StandarizationParameters]
  let bothOSProcessedWalking: [StandarizationParameters]
  let bothOSProcessedWalkingRest: [StandarizationParameters]

  private init?() {
    do {
      iOSRawRest = try StandarizeDataManager
        .map(path: try File.iOSRawRest.standarizationParametersPath())

      iOSRawWalking = try StandarizeDataManager
        .map(path: try File.iOSRawWalking.standarizationParametersPath())

      watchOSRawRest = try StandarizeDataManager
        .map(path: try File.watchOSRawRest.standarizationParametersPath())

      watchOSRawWalking = try StandarizeDataManager
        .map(path: try File.watchOSRawWalking.standarizationParametersPath())

      iOSProcessedRest = try StandarizeDataManager
        .map(path: try File.iOSProcessedRest.standarizationParametersPath())

      iOSProcessedWalking = try StandarizeDataManager
        .map(path: try File.iOSProcessedWalking.standarizationParametersPath())

      watchOSProcessedRest = try StandarizeDataManager
        .map(path: try File.watchOSProcessedRest.standarizationParametersPath())

      watchOSProcessedWalking  = try StandarizeDataManager
        .map(path: try File.watchOSProcessedWalking.standarizationParametersPath())

      bothOSRawRest = try StandarizeDataManager
        .map(path: try File.iOSWatchOSRawMergedRest.standarizationParametersPath())

      bothOSRawWalking = try StandarizeDataManager
        .map(path: try File.iOSWatchOSRawMergedWalking.standarizationParametersPath())

      bothOSRawWalkingRest = try StandarizeDataManager
        .map(path: try File.iOSWatchOSRawMergedWalkingRest.standarizationParametersPath())

      bothOSProcessedRest = try StandarizeDataManager
        .map(path: try File.iOSWatchOSProcessedMergedRest.standarizationParametersPath())

      bothOSProcessedWalking = try StandarizeDataManager
        .map(path: try File.iOSWatchOSProcessedMergedWalking.standarizationParametersPath())

      bothOSProcessedWalkingRest = try StandarizeDataManager
        .map(path: try File.iOSWatchOSProcessedMergedWalkingRest.standarizationParametersPath())

    } catch let error {
      print(error)
      return nil
    }
  }

  private static func map(path: String) throws -> [StandarizationParameters] {
    let url = URL(fileURLWithPath: path)
    let data = try Data(contentsOf: url)

    guard let json = try JSONSerialization
      .jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] else {
        throw "Couldn't serialize dictionary"
    }

    return json.flatMap { StandarizationParameters(JSON: $0) }
  }
}
