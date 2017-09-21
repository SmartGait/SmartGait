//
//  CMAcceleration.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 20/04/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreMotion
import Foundation
import GLKit

extension CMAcceleration {
  func convertToGLKVector() -> GLKVector3 {
    return GLKVector3Make(Float(self.x), Float(self.y), Float(self.z))
  }

  func accelerationInSensorCoordinateSystem(attitude: CMAttitude) -> GLKVector3 {
    let rotationMatrix = attitude.rotationMatrixInSensorCoordinateSystem()

    return GLKMatrix3MultiplyVector3(rotationMatrix, convertToGLKVector())
  }

  func acceleration(inReferenceFrame referenceFrame: CMAttitude) -> CMAcceleration {
    let rYawZ = CMRotationMatrix(
      m11: cos(referenceFrame.yaw), m12: -sin(referenceFrame.yaw), m13: 0,
      m21: sin(referenceFrame.yaw), m22: cos(referenceFrame.yaw), m23: 0,
      m31: 0, m32: 0, m33: 1)
      .convertToGLKMatrix()

    let acceleration = GLKMatrix3MultiplyVector3(rYawZ, convertToGLKVector())

    return CMAcceleration(x: Double(acceleration.x), y: Double(acceleration.y), z: Double(acceleration.z))
  }
}
