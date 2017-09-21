//
//  MeasurementViewModel.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 25/01/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct MeasurementViewModel {
  let name: String
  let x: Variable<Double>
  let y: Variable<Double>
  let z: Variable<Double>
  let w: Variable<Double?>

  init(name: String, x: Double, y: Double, z: Double, w: Double? = nil) {
    self.name = name
    self.x = Variable(x)
    self.y = Variable(y)
    self.z = Variable(z)
    self.w = Variable(w)
  }

  func updateValues(threeAxis: ThreeAxisVector) {
    x.value = threeAxis.x
    y.value = threeAxis.y
    z.value = threeAxis.z
  }

  func updateValues(fourAxis: FourAxisVector) {
    updateValues(threeAxis: fourAxis)
    w.value = fourAxis.w
  }
}
