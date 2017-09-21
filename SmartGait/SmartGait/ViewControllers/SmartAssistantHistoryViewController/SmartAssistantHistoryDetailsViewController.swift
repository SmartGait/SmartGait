//
//  SmartAssistantHistoryDetailsViewController.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 14/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import UIKit
import CoreData
import RxCoreData
import RxSwift

//swiftlint:disable type_name
class SmartAssistantHistoryDetailsViewController<ViewModel: SmartAssistantHistoryDetailsViewModel>: UIViewController {
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var sendButton: UIButton!
  var viewModel: ViewModel!

  var context: NSManagedObjectContext? {
    return CoreDataManager.sharedInstance.backgroundContext
  }

  init(nibName: String = "SmartAssistantHistoryDetailsViewController") {
    super.init(nibName: nibName, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    edgesForExtendedLayout = UIRectEdge([])
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

        do {
          try self.context?.rx.update(self.viewModel)
        } catch let error {
          print(error)
        }

        self.navigationController?.popViewController(animated: true)
      })
      .subscribe()
      .addDisposableTo(rx_disposeBag)

    viewModel
      .sending
      .asObservable()
      .observeOn(MainScheduler.instance)
      .do(onNext: { (sending) in
        self.sendButton.setTitle(sending ? "Sending..." : "Send", for: .normal)
      })
      .subscribe()
      .addDisposableTo(rx_disposeBag)

    let dateString = DateFormatter.localizedString(from: viewModel.startDate, dateStyle: .short, timeStyle: .medium)

    titleLabel.text = "\(viewModel.identifier) - \(dateString)"
  }

  @IBAction func send(_ sender: UIButton) {
    viewModel.send()
  }
}
