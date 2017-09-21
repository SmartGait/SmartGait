//
//  Buffer.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 04/05/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation

protocol Buffer: class {
  associatedtype DataType
  var queue: DispatchQueue { get set }
  var data: [DataType] { get set }

  func append(data: DataType)
  func reset()
  func getData() -> [DataType]
  func getDataCopy() throws -> [DataType]
}

extension Buffer {
  func append(data: DataType) {
    queue.sync {
      self.data.append(data)
    }
  }

  func reset() {
    queue.sync {
      data = []
    }
  }

  func getData() -> [DataType] {
    var result: [DataType] = []
    queue.sync {
      result = data
    }
    return result
  }

  func getDataCopy() throws -> [DataType] {
    guard let data = NSArray(array: getData(), copyItems: true) as? [DataType] else {
      throw "Couldn't copy data"
    }

    return data
  }
}
