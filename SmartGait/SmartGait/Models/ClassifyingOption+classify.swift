//
//  ClassifyingOption.swift
//
//
//  Created by Francisco Gonçalves on 03/05/2017.
//
//

import Foundation

extension ClassifyingOption {
  //swiftlint:disable cyclomatic_complexity
  func classify<MData: MotionData>(
    mergedData: MergedData<MData>,
    sensitivity: Float
    ) throws -> (summary: String, data: ClassifiableData)? {
    switch self {

    case .iOSRawRest:
      return DataClassification.classify(data: mergedData.iOSData, with: .iOSRawRest, sensitivity: sensitivity)
    case .iOSRawWalking:
      return DataClassification.classify(data: mergedData.iOSData, with: .iOSRawWalking, sensitivity: sensitivity)
    case .watchOSRawRest:
      return DataClassification.classify(data: mergedData.watchOSData, with: .watchOSRawRest, sensitivity: sensitivity)
    case .watchOSRawWalking:
      return DataClassification.classify(data: mergedData.watchOSData, with: .watchOSRawWalking,
                                         sensitivity: sensitivity)
    case .bothOSRawRest:
      return DataClassification.classify(data: mergedData, with: .bothOSRawRest, sensitivity: sensitivity)
    case .bothOSRawWalking:
      return DataClassification.classify(data: mergedData, with: .bothOSRawWalking, sensitivity: sensitivity)
    case .bothOSRawWalkingRest:
      return DataClassification.classify(data: mergedData, with: .bothOSRawWalkingRest, sensitivity: sensitivity)

    case .coreMLBothOSRawRest:
      return try DataClassification.coreMLClassify(data: mergedData, with: .bothOSRawRest, sensitivity: sensitivity)
    case .coreMLBothOSRawWalking:
      return try DataClassification.coreMLClassify(data: mergedData, with: .bothOSRawWalking, sensitivity: sensitivity)
    case .coreMLBothOSRawWalkingRest:
      return try DataClassification.coreMLClassify(data: mergedData, with: .bothOSRawWalkingRest,
                                                   sensitivity: sensitivity)

    case .iOSProcessedRest:
      return DataClassification.classify(data: mergedData.iOSData, with: .iOSProcessedRest, sensitivity: sensitivity)
    case .iOSProcessedWalking:
      return DataClassification.classify(data: mergedData.iOSData, with: .iOSProcessedWalking, sensitivity: sensitivity)
    case .watchOSProcessedRest:
      return DataClassification.classify(data: mergedData.watchOSData, with: .watchOSProcessedRest,
                                         sensitivity: sensitivity)
    case .watchOSProcessedWalking:
      return DataClassification.classify(data: mergedData.watchOSData, with: .watchOSProcessedWalking,
                                         sensitivity: sensitivity)
    case .bothOSProcessedRest:
      return DataClassification.classify(data: mergedData, with: .bothOSProcessedRest, sensitivity: sensitivity)
    case .bothOSProcessedWalking:
      return DataClassification.classify(data: mergedData, with: .bothOSProcessedWalking, sensitivity: sensitivity)
    case .bothOSProcessedWalkingRest:
      return DataClassification.classify(data: mergedData, with: .bothOSProcessedWalkingRest, sensitivity: sensitivity)

    case .staticClassifier:
      return (summary: "static", data: DataClassification.classify(mergedData: mergedData))
    }
  }

  static func options(withType type: MotionData.Type, forActivity activity: MotionActivity) -> [ClassifyingOption] {
    switch type {
    case is RawData.Type:
      switch activity {
      case .unknown, .stationary:
        return [.coreMLBothOSRawRest, .coreMLBothOSRawWalking, .coreMLBothOSRawWalkingRest,
                .iOSRawRest, .watchOSRawRest, .bothOSRawRest, .bothOSRawWalkingRest, .staticClassifier]
      case .walking:
        return [.coreMLBothOSRawRest, .coreMLBothOSRawWalking, .coreMLBothOSRawWalkingRest,
                .iOSRawWalking, .watchOSRawWalking, .bothOSRawWalking, .bothOSRawWalkingRest]
      default:
        return []
      }
    case is ProcessedData.Type:
      switch activity {
      case .unknown, .stationary:
        return [.iOSProcessedRest, .watchOSProcessedRest, .bothOSProcessedRest, .bothOSProcessedWalkingRest,
                .staticClassifier]
      case .walking:
        return [.iOSProcessedWalking, .watchOSProcessedWalking, .bothOSProcessedWalking, .bothOSProcessedWalkingRest]
      default:
        return []
      }
    default:
      fatalError("Not implemented")
    }
  }
}
