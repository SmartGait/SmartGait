//
//  ThreeAxisVector.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 21/04/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreMotion
import Foundation

protocol ThreeAxisVector {
  var x: Double { get set }
  var y: Double { get set }
  var z: Double { get set }
}

extension CMAcceleration: ThreeAxisVector {}
extension CMRotationRate: ThreeAxisVector {}
