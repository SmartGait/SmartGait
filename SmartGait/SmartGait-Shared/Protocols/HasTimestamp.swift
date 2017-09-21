//
//  HasTimestamp.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 21/04/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreMotion
import Foundation

protocol HasTimestamp {
  var timestamp: TimeInterval { get }
}

extension CMDeviceMotion: HasTimestamp {}
extension CMAccelerometerData: HasTimestamp {}
