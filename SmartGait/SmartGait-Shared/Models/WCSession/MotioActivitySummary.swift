//
//  MotioActivitySummary.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 03/05/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import CoreMotion

enum MotionActivity: Int {
  case unknown
  case stationary
  case walking
  case running
  case automotive
  case cycling

  func description() -> String {
    switch self {
    case .unknown:
      return "unknown"
    case .stationary:
      return "stationary"
    case .walking:
      return "walking"
    case .running:
      return "running"
    case .automotive:
      return "automotive"
    case .cycling:
      return "cycling"
    }
  }

  static func map(description: String) throws -> MotionActivity {
    switch description {
    case "unknown":
      return .unknown
    case "stationary":
      return .stationary
    case "walking":
      return .walking
    case "running":
      return .running
    case "automotive":
      return .automotive
    case "cycling":
      return .cycling
    default:
      throw "Couldn't map"
    }
  }

}

struct MotionActivitySummary {
  let unknown: Int
  let stationary: Int
  let walking: Int
  let running: Int
  let automotive: Int
  let cycling: Int
  let last: CMMotionActivity?

  func currentActivity() -> MotionActivity? {
    let activities = [unknown, stationary, walking, running, automotive, cycling]

    let maxValue = activities.max()
    let topActivities = activities.enumerated()
      .filter { $0.element == maxValue }
      .flatMap { MotionActivity(rawValue: $0.offset) }

    print("Top Activities: \(topActivities)")

    if topActivities.count == 1, let activity = topActivities.first {
      if [MotionActivity.walking, MotionActivity.running, MotionActivity.automotive, MotionActivity.cycling]
        .contains(activity) {
        return .walking
      } else if [MotionActivity.unknown, MotionActivity.stationary].contains(activity) {
        return .stationary
      }
    }
    return nil
  }
}
