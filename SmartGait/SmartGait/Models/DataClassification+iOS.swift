//
//  DataClassification+iOS.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 01/05/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation

//swiftlint:disable cyclomatic_complexity
enum Classifier: String {
  case iOSRawRest
  case iOSRawWalking

  case watchOSRawRest
  case watchOSRawWalking

  case bothOSRawRest
  case bothOSRawWalking
  case bothOSRawWalkingRest

  case iOSProcessedRest
  case iOSProcessedWalking

  case watchOSProcessedRest
  case watchOSProcessedWalking

  case bothOSProcessedRest
  case bothOSProcessedWalking
  case bothOSProcessedWalkingRest

  func neuralNet() throws -> NeuralNet {
    switch self {
    case .iOSRawRest:
      return try unwrap(NeuralNetworksManager.sharedInstance?.iOSRawRest)
    case .iOSRawWalking:
      return try unwrap(NeuralNetworksManager.sharedInstance?.iOSRawWalking)
    case .watchOSRawRest:
      return try unwrap(NeuralNetworksManager.sharedInstance?.watchOSRawRest)
    case .watchOSRawWalking:
      return try unwrap(NeuralNetworksManager.sharedInstance?.watchOSRawWalking)
    case .iOSProcessedRest:
      return try unwrap(NeuralNetworksManager.sharedInstance?.iOSProcessedRest)
    case .iOSProcessedWalking:
      return try unwrap(NeuralNetworksManager.sharedInstance?.iOSProcessedWalking)
    case .watchOSProcessedRest:
      return try unwrap(NeuralNetworksManager.sharedInstance?.watchOSProcessedRest)
    case .watchOSProcessedWalking:
      return try unwrap(NeuralNetworksManager.sharedInstance?.watchOSProcessedWalking)
    case .bothOSRawRest:
      return try unwrap(NeuralNetworksManager.sharedInstance?.bothOSRawRest)
    case .bothOSRawWalking:
      return try unwrap(NeuralNetworksManager.sharedInstance?.bothOSRawWalking)
    case .bothOSRawWalkingRest:
      return try unwrap(NeuralNetworksManager.sharedInstance?.bothOSRawWalkingRest)
    case .bothOSProcessedRest:
      return try unwrap(NeuralNetworksManager.sharedInstance?.bothOSProcessedRest)
    case .bothOSProcessedWalking:
      return try unwrap(NeuralNetworksManager.sharedInstance?.bothOSProcessedWalking)
    case .bothOSProcessedWalkingRest:
      return try unwrap(NeuralNetworksManager.sharedInstance?.bothOSProcessedWalkingRest)
    }
  }

  func standarizationParameters() throws -> [StandarizationParameters] {
    switch self {
    case .iOSRawRest:
      return try unwrap(StandarizeDataManager.sharedInstance?.iOSRawRest)
    case .iOSRawWalking:
      return try unwrap(StandarizeDataManager.sharedInstance?.iOSRawWalking)
    case .watchOSRawRest:
      return try unwrap(StandarizeDataManager.sharedInstance?.watchOSRawRest)
    case .watchOSRawWalking:
      return try unwrap(StandarizeDataManager.sharedInstance?.watchOSRawWalking)
    case .iOSProcessedRest:
      return try unwrap(StandarizeDataManager.sharedInstance?.iOSProcessedRest)
    case .iOSProcessedWalking:
      return try unwrap(StandarizeDataManager.sharedInstance?.iOSProcessedWalking)
    case .watchOSProcessedRest:
      return try unwrap(StandarizeDataManager.sharedInstance?.watchOSProcessedRest)
    case .watchOSProcessedWalking:
      return try unwrap(StandarizeDataManager.sharedInstance?.watchOSProcessedWalking)
    case .bothOSRawRest:
      return try unwrap(StandarizeDataManager.sharedInstance?.bothOSRawRest)
    case .bothOSRawWalking:
      return try unwrap(StandarizeDataManager.sharedInstance?.bothOSRawWalking)
    case .bothOSRawWalkingRest:
      return try unwrap(StandarizeDataManager.sharedInstance?.bothOSRawWalkingRest)
    case .bothOSProcessedRest:
      return try unwrap(StandarizeDataManager.sharedInstance?.bothOSProcessedRest)
    case .bothOSProcessedWalking:
      return try unwrap(StandarizeDataManager.sharedInstance?.bothOSProcessedWalking)
    case .bothOSProcessedWalkingRest:
      return try unwrap(StandarizeDataManager.sharedInstance?.bothOSProcessedWalkingRest)
    }
  }

  func coreMLNeuralNet() throws -> CoreMLNeuralNet {
    switch self {
    case .iOSRawRest:
      throw "\(self) CoreML classifier not implemented"
    case .iOSRawWalking:
      throw "\(self) CoreML classifier not implemented"
    case .watchOSRawRest:
      throw "\(self) CoreML classifier not implemented"
    case .watchOSRawWalking:
      throw "\(self) CoreML classifier not implemented"
    case .iOSProcessedRest:
      throw "\(self) CoreML classifier not implemented"
    case .iOSProcessedWalking:
      throw "\(self) CoreML classifier not implemented"
    case .watchOSProcessedRest:
      throw "\(self) CoreML classifier not implemented"
    case .watchOSProcessedWalking:
      throw "\(self) CoreML classifier not implemented"
    case .bothOSRawRest:
      return CoreMLNeuralNetworksManager.sharedInstance.bothOSRawRest
    case .bothOSRawWalking:
      return CoreMLNeuralNetworksManager.sharedInstance.bothOSRawWalking
    case .bothOSRawWalkingRest:
      return CoreMLNeuralNetworksManager.sharedInstance.bothOSRawWalkingRest
    case .bothOSProcessedRest:
      throw "\(self) CoreML classifier not implemented"
    case .bothOSProcessedWalking:
      throw "\(self) CoreML classifier not implemented"
    case .bothOSProcessedWalkingRest:
      throw "\(self) CoreML classifier not implemented"
    }
  }

  private func unwrap<T>(_ object: T?) throws -> T {
    guard let object = object else {
      throw "\(T.self) couln't be instantiated"
    }
    return object
  }

  func map(output: [[Float]]) throws -> Classification {
    guard let classification = output.first, let zero = classification.first, let one = classification.last,
      classification.count == 2 else {
        throw "Couldn't infer"
    }

    return zero > one ? .balanced : .imbalanced
  }
}

extension DataClassification {
  static func classify(
    data: ClassifiableData,
    with classifier: Classifier,
    sensitivity: Float
    ) -> (summary: String, data: ClassifiableData)? {

    var data = data
    let classifications = data.asArray().flatMap { element -> Classification? in
      do {
        let standarizationParameters = try classifier.standarizationParameters()
        let standarizedData = apply(parameters: standarizationParameters, to: element)

        let neuralNet = try classifier.neuralNet()
        let output = try neuralNet.infer([standarizedData])
        let classification = try classifier.map(output: output)
        //        print("\(classifier.rawValue): \(output)")
        return classification
      } catch let error {
        print(error)
        return nil
      }
    }

    var balanced = 0
    var imbalanced = 0
    classifications.forEach { (classification) in
      switch classification {
      case .balanced:
        balanced += 1
      case .imbalanced:
        imbalanced += 1
      }
    }

    let summary = "n_instances: balanced: \(balanced), imbalanced: \(imbalanced), sensitivity: \(sensitivity)"
    print(summary)
    let finalClassification: Classification = (Float(imbalanced) >= (sensitivity * Float(classifications.count)))
      ? .imbalanced : .balanced
    data.updateClassification(dataClassification: DataClassification(classification: finalClassification))
    return (summary: summary, data: data)

  }

  static func coreMLClassify(
    data: ClassifiableData,
    with classifier: Classifier,
    sensitivity: Float
    ) throws -> (summary: String, data: ClassifiableData)? {

    var data = data
    let classifications = try data.asMLMultiArray().flatMap { element -> Classification? in
      do {
        let neuralNet = try classifier.coreMLNeuralNet()
        let output = try neuralNet.classify(input: element)
        let classification = Classification(rawValue: output.classification)
        return classification
      } catch let error {
        print(error)
        return nil
      }
    }

    var balanced = 0
    var imbalanced = 0
    classifications.forEach { (classification) in
      switch classification {
      case .balanced:
        balanced += 1
      case .imbalanced:
        imbalanced += 1
      }
    }

    let summary = "n_instances: balanced: \(balanced), imbalanced: \(imbalanced), sensitivity: \(sensitivity)"
    print(summary)
    let finalClassification: Classification = (Float(imbalanced) >= (sensitivity * Float(classifications.count)))
      ? .imbalanced : .balanced
    //    let finalClassification: Classification = imbalanced > balanced ? .imbalanced : .balanced
    data.updateClassification(dataClassification: DataClassification(classification: finalClassification))
    return (summary: summary, data: data)

  }

  private static func apply(parameters: [StandarizationParameters], to data: [Double]) -> [Float] {
    return data
      .enumerated()
      .map { value -> Float in
        let (index, element) = value //FIXME: Update when SE-0110 is rollbacked
        return Float((element - parameters[index].average) / parameters[index].standardDeviation)
      }
  }
}
