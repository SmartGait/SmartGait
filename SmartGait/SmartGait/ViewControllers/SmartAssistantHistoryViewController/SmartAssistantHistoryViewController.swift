//
//  SmartAssistantHistoryViewController.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 14/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import UIKit
import CoreData
import RxCoreData
import RxSwift

protocol SmartAssistantHistoryViewController: UITableViewDelegate {
  associatedtype ViewModel: SmartAssistantHistoryDetailsViewModel

  weak var tableView: UITableView! { get set }
  var viewModel: SmartAssistantHistoryViewModel<ViewModel>! { get set }
  var disposeBag: DisposeBag! { get set }

  func setupOnLoad()
  func setupBindings(withViewModels viewModels: Observable<[ViewModel]>)
  func setupTableViewBindings()
  func push(viewController: UIViewController)
}

extension SmartAssistantHistoryViewController {
  var context: NSManagedObjectContext? {
    return CoreDataManager.sharedInstance.backgroundContext
  }

  func setupOnLoad() {
    self.tableView.allowsMultipleSelectionDuringEditing = false

    do {
      self.viewModel = try SmartAssistantHistoryViewModel()
      self.disposeBag = DisposeBag()
      setupBindings(withViewModels: viewModel.viewModels)
      setupTableViewBindings()
    } catch let error {
      // Should update UI
      print(error)
    }
  }

  func setupBindings(withViewModels viewModels: Observable<[ViewModel]>) {
    viewModels
      .bind(to: tableView.rx.items(cellIdentifier: "SmartAssistantHistoryTableViewCell")) { _, viewModel, cell in
        guard let cell = cell as? SmartAssistantHistoryTableViewCell else {
          return
        }

        cell.update(withViewModel: viewModel)
      }
      .addDisposableTo(disposeBag)
  }

  func setupTableViewBindings() {
    tableView.rx.itemSelected
      .map { indexPath -> ViewModel? in
        try? self.tableView.rx.model(at: indexPath)
      }
      .unwrap()
      .do(onNext: { viewModel in
        let viewController = SmartAssistantHistoryDetailsViewController<ViewModel>()

        viewController.viewModel = viewModel

        self.push(viewController: viewController)
      })
      .subscribe()
      .addDisposableTo(disposeBag)

    tableView.rx.itemDeleted
      .map { [unowned self] indexPath -> ViewModel in
        return try self.tableView.rx.model(at: indexPath)
      }
      .subscribe(onNext: { [unowned self] (event) in
        do {
          try self.context?.rx.delete(event)
        } catch let error {
          print(error)
        }
      })
      .addDisposableTo(disposeBag)

    tableView.rx
      .setDelegate(self)
      .addDisposableTo(disposeBag)
  }
}
