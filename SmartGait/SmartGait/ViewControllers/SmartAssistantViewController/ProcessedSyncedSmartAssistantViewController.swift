//
//  ViewController.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 24/01/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreData
import RxCocoa
import RxSwift
import UIKit
import WatchConnectivity
import AVFoundation

//swiftlint:disable type_name
class ProcessedSyncedSmartAssistantViewController: UIViewController {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!

  fileprivate var viewModel: SyncedSmartAssistantViewModel<ProcessedData, ProcessedClassificationTaskModel>!

  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel = SyncedSmartAssistantViewModel(frequency: 100)

    viewModel.classifyingOptionViewModels
      .asObservable()
      .bind(to: tableView.rx.items(cellIdentifier: "SyncedSmartAssistantTableViewCell")) { _, viewModel, cell in
        guard let cell = cell as? SyncedSmartAssistantTableViewCell else {
          return
        }

        cell.update(withViewModel: viewModel)
      }
      .addDisposableTo(rx_disposeBag)

    tableView.rx.itemSelected
      .do(onNext: { indexPath in
        let viewModel = self.viewModel.classifyingOptionViewModels.value[indexPath.row]
        viewModel.toggle()
        self.tableView.cellForRow(at: indexPath)?.accessoryType = viewModel.selected ? .checkmark : .none
      })
      .subscribe()
      .addDisposableTo(rx_disposeBag)
  }
}

// MARK: - API
extension ProcessedSyncedSmartAssistantViewController {
  func start(data: StartSmartAssistant) {
    viewModel.startSmartAssistant(with: data.startTime)
  }

  func handle(processedData: ProcessedData, replyHandler: @escaping (([String : Any]) -> Void)) {
    viewModel.handle(processedData: processedData, replyHandler: replyHandler)
  }

  func resume() {
    viewModel.resume()
  }

  func stop() {
    viewModel.stop()
  }
}
