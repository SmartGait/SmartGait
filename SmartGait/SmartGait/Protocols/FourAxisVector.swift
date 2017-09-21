//
//  FourAxisVector.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 21/04/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreMotion
import Foundation

protocol FourAxisVector: ThreeAxisVector {
  var w: Double { get set }
}

extension CMQuaternion: FourAxisVector {}
