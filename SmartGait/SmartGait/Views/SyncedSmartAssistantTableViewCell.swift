//
//  SyncedSmartAssistantTableViewCell.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 02/05/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import UIKit

class SyncedSmartAssistantTableViewCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!

  func update(withViewModel viewModel: ClassifyingOptionViewModel) {
    titleLabel.text = viewModel.title
    accessoryType = viewModel.selected ? .checkmark : .none
  }
}
