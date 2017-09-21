//
//  SendableData.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 03/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation

protocol SendableData {
  static var startSmartAssistant: String { get }
  static var stopSmartAssistant: String { get }
  static var resumeSmartAssistant: String { get }
  static var updateSmartAssistantSensivity: String { get }
  static var nextDataElement: String { get }
}
