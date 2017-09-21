//
//  SmartAssistantTableViewCell.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 24/05/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation

class SmartAssistantHistoryTableViewCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!

  func update<ViewModel: SmartAssistantHistoryDetailsViewModel>(withViewModel viewModel: ViewModel) {
    let dateString = DateFormatter.localizedString(from: viewModel.startDate, dateStyle: .short, timeStyle: .medium)

    titleLabel.text = "\(viewModel.identifier) - \(dateString) "
  }
}
