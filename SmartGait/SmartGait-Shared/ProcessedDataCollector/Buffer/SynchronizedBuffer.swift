//
//  SynchronizedBuffer.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 04/05/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation

class SynchronizedBuffer<DataType>: Buffer {
  var queue: DispatchQueue
  var data: [DataType]

  init(
    data: [DataType] = [],
    queue: DispatchQueue = DispatchQueue(label: "me.franciscocsg.SynchronizedBuffer", attributes: .concurrent)
    ) {
    self.queue = queue
    self.data = data
  }
}
