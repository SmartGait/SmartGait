//
//  RawSmartAssistantHistoryViewController.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 14/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreData
import Foundation
import RxCocoa
import RxSwift
import UIKit

class RawSmartAssistantHistoryViewController: UIViewController, SmartAssistantHistoryViewController {

  @IBOutlet weak var tableView: UITableView!

  var viewModel: SmartAssistantHistoryViewModel<RawSmartAssistantHistoryDetailsViewModel>!
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
