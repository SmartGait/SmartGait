//
//  CMRotationMatrix.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 20/04/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreMotion
import Foundation
import GLKit

extension CMRotationMatrix {
  func convertToGLKMatrix() -> GLKMatrix3 {
    return GLKMatrix3Make(
      Float(m11), Float(m12), Float(m13),
      Float(m21), Float(m22), Float(m23),
      Float(m31), Float(m32), Float(m33))
  }
}
