//
//  MLMultiArray+Append.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 27/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreML
import Foundation

@available(watchOSApplicationExtension 4.0, *)
extension MLMultiArray {
  // This method can only append single shaped MLMultiArrays
  static func append(_ array1: MLMultiArray, _ array2: MLMultiArray) throws -> MLMultiArray {
    // Assumes both arrays have a single shape
    guard let array1Shape = array1.shape.first, let array2Shape = array2.shape.first else {
      throw "Couldn't get shape"
    }
    let array1Count = Int(array1Shape)
    let array2Count = Int(array2Shape)

    // sums shapes of both arrays
    let shape = array1Count + array2Count

    // creates new multiarray
    let data = try MLMultiArray(shape: [NSNumber(value: shape)], dataType: .double)

    // loops from 0 to shape count
    for index in 0..<shape {
      if index < array1Count { // index less than array1 count
        data[index] = array1[index]
      }
      // as index is bigger than array1 count, check if its module is less than array count 2. if so use that value
      // to subscript array2
      else if index % array1Count < array2Count {
        data[index] = array2[index % array1Count]
      }
    }
    return data
  }
}
