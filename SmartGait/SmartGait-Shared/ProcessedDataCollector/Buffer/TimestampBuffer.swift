//
//  DeviceMotionBuffer.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 30/03/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation

class TimestampBuffer<DataType: HasTimestamp>: TimedBuffer {
  var queue: DispatchQueue
  var data: [DataType]
  var bufferTimeLimit: Double
  var interval: Double

  init(
    startingTime: TimeInterval,
    data: [DataType] = [],
    queue: DispatchQueue = DispatchQueue(label: "me.franciscocsg.TimestampBuffer", attributes: .concurrent),
    interval: Double = 0.2
    ) {
    self.queue = queue
    self.data = data
    self.interval = interval
    self.bufferTimeLimit = startingTime + interval
  }

  func isFull() -> Bool {
    var result = false
    queue.sync {
      guard data.first != nil, let last = data.last else {
        return
      }
      result = UnixTimeOffset.sharedInstance.unixTimestamp(timestamp: last.timestamp) > bufferTimeLimit
    }
    return result
  }
}
