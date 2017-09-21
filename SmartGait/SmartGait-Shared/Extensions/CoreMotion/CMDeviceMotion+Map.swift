//
//  CMDeviceMotion+Map.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 05/02/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import CoreMotion

extension CMDeviceMotion {
  func mapToDeviceMotionData() -> DeviceMotionData {
    let attitude = Attitude(self.attitude)

    let rotationRate = DeviceMotionAcceleration(self.rotationRate)

    let userAcceleration = DeviceMotionAcceleration(self.userAcceleration)

    let gravity = DeviceMotionAcceleration(self.gravity)

    let magneticField = MagneticField(self.magneticField)

    return DeviceMotionData(attitude: attitude,
                            rotationRate: rotationRate,
                            userAcceleration: userAcceleration,
                            gravity: gravity,
                            magneticField: magneticField,
                            timestamp: UnixTimeOffset.sharedInstance.unixTimestamp(timestamp: self.timestamp))
  }
}
