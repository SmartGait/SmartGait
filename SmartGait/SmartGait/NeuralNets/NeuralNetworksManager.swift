//
//  NeuralNetworksManager.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 01/05/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation

struct NeuralNetworksManager {
  static let sharedInstance: NeuralNetworksManager? = NeuralNetworksManager()

  let iOSRawRest: NeuralNet
  let iOSRawWalking: NeuralNet

  let watchOSRawRest: NeuralNet
  let watchOSRawWalking: NeuralNet

  let iOSProcessedRest: NeuralNet
  let iOSProcessedWalking: NeuralNet

  let watchOSProcessedRest: NeuralNet
  let watchOSProcessedWalking: NeuralNet

  let bothOSRawRest: NeuralNet
  let bothOSRawWalking: NeuralNet
  let bothOSRawWalkingRest: NeuralNet

  let bothOSProcessedRest: NeuralNet
  let bothOSProcessedWalking: NeuralNet
  let bothOSProcessedWalkingRest: NeuralNet

  private init?() {
    do {
      iOSRawRest = try NeuralNet(url: URL(fileURLWithPath: try File.iOSRawRest.neuralNetPath()))
      iOSRawWalking = try NeuralNet(url: URL(fileURLWithPath: try File.iOSRawWalking.neuralNetPath()))

      watchOSRawRest = try NeuralNet(url: URL(fileURLWithPath: try File.watchOSRawRest.neuralNetPath()))
      watchOSRawWalking = try NeuralNet(url: URL(fileURLWithPath: try File.watchOSRawWalking.neuralNetPath()))

      iOSProcessedRest = try NeuralNet(url: URL(fileURLWithPath: try File.iOSProcessedRest.neuralNetPath()))
      iOSProcessedWalking = try NeuralNet(url: URL(fileURLWithPath: try File.iOSProcessedWalking.neuralNetPath()))

      watchOSProcessedRest = try NeuralNet(url: URL(fileURLWithPath: try File.watchOSProcessedRest.neuralNetPath()))
      watchOSProcessedWalking = try NeuralNet(
        url: URL(fileURLWithPath: try File.watchOSProcessedWalking.neuralNetPath()))

      bothOSRawRest = try NeuralNet(
        url: URL(fileURLWithPath: try File.iOSWatchOSRawMergedRest.neuralNetPath()))
      bothOSRawWalking = try NeuralNet(
        url: URL(fileURLWithPath: try File.iOSWatchOSRawMergedWalking.neuralNetPath()))
      bothOSRawWalkingRest = try NeuralNet(
        url: URL(fileURLWithPath: try File.iOSWatchOSRawMergedWalkingRest.neuralNetPath()))

      bothOSProcessedRest = try NeuralNet(
        url: URL(fileURLWithPath: try File.iOSWatchOSProcessedMergedRest.neuralNetPath()))
      bothOSProcessedWalking = try NeuralNet(
        url: URL(fileURLWithPath: try File.iOSWatchOSProcessedMergedWalking.neuralNetPath()))
      bothOSProcessedWalkingRest = try NeuralNet(
        url: URL(fileURLWithPath: try File.iOSWatchOSProcessedMergedWalkingRest.neuralNetPath()))
    } catch let error {
      print(error)
      return nil
    }
  }
}
