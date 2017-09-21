//
//  ClassifyingOption.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 27/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation

enum ClassifyingOption: String {
  case iOSRawRest = "iOS Raw Rest"
  case iOSRawWalking = "iOS Raw Walking"

  case watchOSRawRest = "watchOS Raw Rest"
  case watchOSRawWalking = "watchOS Raw Walking"

  case bothOSRawRest = "Both Raw Rest"
  case bothOSRawWalking = "Both Raw Walking"
  case bothOSRawWalkingRest = "Both Raw Walking and Resting"

  case coreMLBothOSRawRest = "CoreML Both Raw Rest"
  case coreMLBothOSRawWalking = "CoreML Both Raw Walking"
  case coreMLBothOSRawWalkingRest = "CoreML Both Raw Walking and Resting"

  case iOSProcessedRest = "iOS Processed Rest"
  case iOSProcessedWalking = "iOS Processed Walking"

  case watchOSProcessedRest = "watchOS Processed Rest"
  case watchOSProcessedWalking = "watchOS Processed Walking"

  case bothOSProcessedRest = "Both Processed Rest"
  case bothOSProcessedWalking = "Both Processed Walking"
  case bothOSProcessedWalkingRest = "Both Processed Walking and Resting"

  case staticClassifier = "Static"

  static func allOptions(forType type: MotionData.Type) -> [ClassifyingOption] {
    switch type {
    case is RawData.Type:
      return [
        .coreMLBothOSRawRest,
        .coreMLBothOSRawWalking,
        .coreMLBothOSRawWalkingRest,
        .iOSRawRest,
        .iOSRawWalking,
        .watchOSRawRest,
        .watchOSRawWalking,
        .bothOSRawRest,
        .bothOSRawWalking,
        .bothOSRawWalkingRest,

        .staticClassifier
      ]
    case is ProcessedData.Type:
      return [
        .iOSProcessedRest,
        .iOSProcessedWalking,
        .watchOSProcessedRest,
        .watchOSProcessedWalking,
        .bothOSProcessedRest,
        .bothOSProcessedWalking,
        .bothOSProcessedWalkingRest,

        .staticClassifier
      ]
    default:
      fatalError("Not implemented")
    }
  }
}
