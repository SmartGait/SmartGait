//
//  HistoryViewController.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 18/03/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import UIKit
import CoreData
import RxSwift
import RxCoreData
import RxSwiftExt

class ResearchHistoryViewController: UIViewController, UITableViewDelegate {

  @IBOutlet weak var tableView: UITableView!

  var context: NSManagedObjectContext? {
    return CoreDataManager.sharedInstance.viewContext
  }

  var viewModel: ResearchHistoryViewModel?

  override func viewDidLoad() {
    super.viewDidLoad()

    self.tableView.allowsMultipleSelectionDuringEditing = false

    do {
      let viewModel = try ResearchHistoryViewModel()
      self.viewModel = viewModel
      setupBindings(withViewModels: viewModel.viewModels)
      setupTableViewBindings()
    } catch let error {
      // Should update UI
      print(error)
    }
  }

  func setupBindings(withViewModels viewModels: Observable<[ResearchHistoryDetailsViewModel]>) {
    viewModels
      .bind(to: tableView.rx.items(cellIdentifier: "ResearchHistoryTableViewCell")) { _, viewModel, cell in
        guard let cell = cell as? ResearchHistoryTableViewCell else {
          return
        }

        cell.update(withViewModel: viewModel)
      }
      .addDisposableTo(rx_disposeBag)
  }
}

extension ResearchHistoryViewController {
  func setupTableViewBindings() {
    tableView.rx.itemSelected
      .map { indexPath -> ResearchHistoryDetailsViewModel? in
        try? self.tableView.rx.model(at: indexPath)
      }
      .unwrap()
      .do(onNext: { viewModel in
        guard let viewController = UIStoryboard(name: "Main", bundle: nil)
          .instantiateViewController(
            withIdentifier: "ResearchHistoryDetailsViewController") as? ResearchHistoryDetailsViewController else {
              return
        }

        viewController.viewModel = viewModel

        self.navigationController?.pushViewController(viewController, animated: true)
      })
      .subscribe()
      .addDisposableTo(rx_disposeBag)

    tableView.rx.itemDeleted
      .map { [unowned self] indexPath -> ResearchHistoryDetailsViewModel in
        return try self.tableView.rx.model(at: indexPath)
      }
      .subscribe(onNext: { [unowned self] (event) in
        do {
          try self.context?.rx.delete(event)
        } catch let error {
          print(error)
        }
      })
      .addDisposableTo(rx_disposeBag)

    tableView.rx
      .setDelegate(self)
      .addDisposableTo(rx_disposeBag)
  }

  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
    return .delete
  }
}
