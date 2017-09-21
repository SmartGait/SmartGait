//
//  CMAccelerometerData+Map.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 05/02/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import CoreMotion

extension CMAccelerometerData {
  func mapToAccelerometerData() -> AccelerometerData {
    return AccelerometerData(self)
  }
}
