//
//  HistoryDetailsViewController.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 18/03/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import UIKit
import CoreData
import RxCoreData
import RxSwift

class ResearchHistoryDetailsViewController: UIViewController {
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var titleLabel: UILabel!
  var viewModel: ResearchHistoryDetailsViewModel!

  var context: NSManagedObjectContext? {
    return CoreDataManager.sharedInstance.backgroundContext
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationController?.isToolbarHidden = false

    let rightButton = UIBarButtonItem(title: "Save", style: .plain, target: nil, action: nil)

    self.navigationItem.rightBarButtonItem = rightButton

    rightButton
      .rx.tap
      .do(onNext: { _ in
        guard let title = self.titleTextField.text else {
          return
        }

        let identifier = self.viewModel.identifier.components(separatedBy: " - ").first ?? self.viewModel.identifier
        self.viewModel.identifier = "\(identifier) - \(title)"
        try? self.context?.rx.update(self.viewModel)
        self.navigationController?.popViewController(animated: true)
      })
      .subscribe()
      .addDisposableTo(rx_disposeBag)

    let dateString = DateFormatter.localizedString(from: viewModel.startDate, dateStyle: .short, timeStyle: .medium)

    titleLabel.text = "\(viewModel.identifier) - \(dateString)"
  }
}
