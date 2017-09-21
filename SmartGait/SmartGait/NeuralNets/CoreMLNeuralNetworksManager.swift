//
//  CoreMLNeuralNetworksManager.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 25/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreML
import Foundation

protocol CoreMLOutput {
  var classificationProbs: [String : Double] { get }
  var classification: String { get }
}

protocol CoreMLNeuralNet {
  func classify(input: MLMultiArray) throws -> CoreMLOutput
}

extension MergedRestClassifier: CoreMLNeuralNet {
  func classify(input: MLMultiArray) throws -> CoreMLOutput {
    return try self.prediction(input: input)
  }
}

extension MergedWalkingClassifier: CoreMLNeuralNet {
  func classify(input: MLMultiArray) throws -> CoreMLOutput {
    return try self.prediction(input: input)
  }
}

extension MergedWalkingRestClassifier: CoreMLNeuralNet {
  func classify(input: MLMultiArray) throws -> CoreMLOutput {
    return try self.prediction(input: input)
  }
}

extension MergedRestClassifierOutput: CoreMLOutput { }
extension MergedWalkingClassifierOutput: CoreMLOutput { }
extension MergedWalkingRestClassifierOutput: CoreMLOutput { }

struct CoreMLNeuralNetworksManager {
  static let sharedInstance: CoreMLNeuralNetworksManager = CoreMLNeuralNetworksManager()

  let bothOSRawRest: MergedRestClassifier
  let bothOSRawWalking: MergedWalkingClassifier
  let bothOSRawWalkingRest: MergedWalkingRestClassifier

  private init() {
    bothOSRawRest = MergedRestClassifier()
    bothOSRawWalking = MergedWalkingClassifier()
    bothOSRawWalkingRest = MergedWalkingRestClassifier()
  }
}
