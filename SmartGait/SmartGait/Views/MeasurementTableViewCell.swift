//
//  MeasurementTableViewCell.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 25/01/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MeasurementTableViewCell: UITableViewCell {
  @IBOutlet weak var xValue: UILabel!
  @IBOutlet weak var yValue: UILabel!
  @IBOutlet weak var zValue: UILabel!
  @IBOutlet weak var wValue: UILabel!
  @IBOutlet weak var measurement: UILabel!

  let disposeBag = DisposeBag()

  override func awakeFromNib() {
    super.awakeFromNib()
    wValue.isHidden = true
  }

  func update(withMeasurementViewModel measurementViewModel: MeasurementViewModel) {
    measurement.text = measurementViewModel.name

    measurementViewModel.x.asObservable()
      .map { x -> String? in
        return "x: \(x)"
      }
      .bind(to: xValue.rx.text)
      .addDisposableTo(disposeBag)

   measurementViewModel.y.asObservable()
      .map { y -> String? in
        return "y: \(y)"
      }
      .bind(to: yValue.rx.text)
      .addDisposableTo(disposeBag)

    measurementViewModel.z.asObservable()
      .map { z -> String? in
        return "z: \(z)"
      }
      .bind(to: zValue.rx.text)
      .addDisposableTo(disposeBag)

    measurementViewModel.w
      .asObservable()
      .unwrap()
      .map { w -> String? in
        self.wValue.isHidden = false
        return "w: \(w)"
      }
      .bind(to: wValue.rx.text)
      .addDisposableTo(disposeBag)
  }
}
