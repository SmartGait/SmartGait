//
//  MeasurementsViewController.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 14/03/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MeasurementsViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var resetButton: UIButton!
  let viewModel = MeasurementsViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()

    resetButton.rx.tap
      .asObservable().bind { _ in   //FIXME: Update when SE-0110 is rollbacked
        self.viewModel.reset.value = true
      }
      .addDisposableTo(rx_disposeBag)

    setupTableView()
  }

  func setupTableView() {
    viewModel.viewModels.asObservable()
      .bind(to: tableView.rx.items) { (tableView, row, _) in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MeasurementTableViewCell")
          as? MeasurementTableViewCell else {
            return UITableViewCell()
        }
        cell.update(withMeasurementViewModel: self.viewModel.viewModels.value[row])
        return cell
      }
      .addDisposableTo(rx_disposeBag)
  }
}
