//
//  TimeLimitBuffer.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 04/05/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation

class TimeLimitBuffer<DataType>: TimedBuffer {
  var queue: DispatchQueue
  var data: [DataType]
  var bufferTimeLimit: Double
  var interval: Double

  init(
    startingTime: TimeInterval = Date().timeIntervalSince1970,
    data: [DataType] = [],
    queue: DispatchQueue = DispatchQueue(label: "me.franciscocsg.TimeLimitBuffer", attributes: .concurrent),
    interval: Double = 3
    ) {
    self.queue = queue
    self.data = data
    self.interval = interval
    self.bufferTimeLimit = startingTime + interval
  }

  func isFull() -> Bool {
    return Date().timeIntervalSince1970 - bufferTimeLimit > interval
  }

  func reset() {
    queue.sync {
      data = []
      bufferTimeLimit = Date().timeIntervalSince1970 + interval
    }
  }
}
