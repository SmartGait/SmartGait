//
//  Result.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 26/01/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import ObjectMapper

protocol TaskResult: Mappable {
  var identifier: String! { get set }
  var startDate: Date! { get set }
  var endDate: Date! { get set }
  var fileURL: URL? { get set }
}

enum TaskResultEnum: String {
  case accelerometer
  case deviceMotion

  func result(startDate: Date, endDate: Date, identifier: String, fileURL: URL?) -> TaskResult {
    switch self {
    case .accelerometer:
      return AccelerometerResult(identifier: identifier,
                                 startDate: startDate,
                                 endDate: endDate,
                                 fileURL: fileURL,
                                 data: nil)
    case .deviceMotion:
      return DeviceMotionResult(identifier: identifier,
                                startDate: startDate,
                                endDate: endDate,
                                fileURL: fileURL,
                                data: nil)
    }
  }
}
