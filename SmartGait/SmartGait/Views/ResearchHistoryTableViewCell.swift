//
//  HistoryTableViewCell.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 18/03/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import UIKit

class ResearchHistoryTableViewCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!

  func update(withViewModel viewModel: ResearchHistoryDetailsViewModel) {
    let dateString = DateFormatter.localizedString(from: viewModel.startDate, dateStyle: .short, timeStyle: .medium)

    titleLabel.text = "\(viewModel.identifier) - \(dateString) "
  }
}
