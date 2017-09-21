//
//  Data.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 02/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import CoreMotion
import CoreData
import ObjectMapper

//swiftlint:disable type_name
protocol MotionData: class, Mappable, ClassifiableData, SendableData {
  var identifier: Int! { get set }
  var initialTimestamp: Double! { get set }
  var finalTimestamp: Double! { get set }
  var samplesUsed: Int! { get set }
  var currentActivity: MotionActivity! { get set }

  var dataClassification: DataClassification? { get set }

  static func handle(motionData: [CMDeviceMotion],
                     motionActivity: [CMMotionActivity],
                     with identifier: Int,
                     last: MotionData?) throws -> MotionData

  static func computeCurrentActivity(data: [CMMotionActivity], lastActivity: MotionActivity?) -> MotionActivity

  static func applyStaticClassification(data: MotionData) -> Classification?

  func timestamps() -> [Double]
}

extension MotionData {
  static func computeCurrentActivity(data: [CMMotionActivity], lastActivity: MotionActivity?) -> MotionActivity {
    let lastActivity = lastActivity ?? .stationary
    guard data.count > 0 else {
      return lastActivity
    }

    let initialResult = MotionActivitySummary(
      unknown: 0,
      stationary: 0,
      walking: 0,
      running: 0,
      automotive: 0,
      cycling: 0,
      last: data.first
    )

    return data.reduce(initialResult) { (res, activity) -> MotionActivitySummary in
      return MotionActivitySummary(unknown: activity.unknown ? res.unknown + 1 : res.unknown,
                                   stationary: activity.stationary ? res.stationary + 1 : res.stationary,
                                   walking: activity.walking ? res.walking + 1 : res.walking,
                                   running: activity.running ? res.running + 1 : res.running,
                                   automotive: activity.automotive ? res.automotive + 1 : res.automotive,
                                   cycling: activity.cycling ? res.cycling + 1 : res.cycling,
                                   last: activity)
      }.currentActivity() ?? lastActivity
  }
}
