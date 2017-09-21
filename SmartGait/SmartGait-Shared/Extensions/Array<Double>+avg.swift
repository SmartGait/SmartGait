//
//  Array<Double>+avg.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 07/02/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation

// See more here: http://blog.krzyzanowskim.com/2015/10/07/generic-array-uint8/
// This extension should be updated when Swift 3.1 is released as it will be possible to define Element == Double
extension Array where Element: _DoubleType {
  func avg() -> Double? {
    guard self.count > 0 else {
      return nil
    }

    return reduce(0) {$0 + $1.value} / Double(self.count)
  }
}

protocol _DoubleType {
  var value: Double { get }
}

extension Double: _DoubleType {
  var value: Double {
    return self
  }
}
