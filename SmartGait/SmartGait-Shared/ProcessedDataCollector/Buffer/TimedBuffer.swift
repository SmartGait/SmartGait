//
//  TimedBuffer.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 04/05/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation

protocol TimedBuffer: Buffer {
  var bufferTimeLimit: Double { get set }
  var interval: Double { get set }
  func isFull() -> Bool
}

extension TimedBuffer {
  func append(data: DataType) {
    if !isFull() {
      queue.sync {
        self.data.append(data)
      }
    }
  }

  func reset() {
    queue.sync {
      data = []
      bufferTimeLimit += interval
    }
  }
}
