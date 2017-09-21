//
//  ProcessedSmartAssistantHistoryViewController.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 24/05/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreData
import Foundation
import RxCocoa
import RxSwift
import UIKit

class ProcessedSmartAssistantHistoryViewController: UIViewController, SmartAssistantHistoryViewController {

  @IBOutlet weak var tableView: UITableView!

  var viewModel: SmartAssistantHistoryViewModel<ProcessedSmartAssistantHistoryDetailsViewModel>!
  var disposeBag: DisposeBag!

  override func viewDidLoad() {
    super.viewDidLoad()
    setupOnLoad()
  }

  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
    return .delete
  }

  func push(viewController: UIViewController) {
    self.navigationController?.pushViewController(viewController, animated: true)
  }
}
