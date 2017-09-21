//
//  CMAttitude.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 20/04/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreMotion
import Foundation
import GLKit

extension CMAttitude {
  func rotationMatrixInSensorCoordinateSystem() -> GLKMatrix3 {
    let rYawZ = CMRotationMatrix(
      m11: cos(yaw), m12: -sin(yaw), m13: 0,
      m21: sin(yaw), m22: cos(yaw), m23: 0,
      m31: 0, m32: 0, m33: 1)
      .convertToGLKMatrix()

    let rPitchY = CMRotationMatrix(
      m11: cos(pitch), m12: 0, m13: sin(pitch),
      m21: 0, m22: 1, m23: 0,
      m31: -sin(pitch), m32: 0, m33: cos(pitch))
      .convertToGLKMatrix()

    let rRollX = CMRotationMatrix(
      m11: 1, m12: 0, m13: 0,
      m21: 0, m22: cos(roll), m23: -sin(roll),
      m31: sin(roll), m32: 0, m33: cos(roll))
      .convertToGLKMatrix()

    return GLKMatrix3Multiply(GLKMatrix3Multiply(rYawZ, rPitchY), rRollX)
  }
}
