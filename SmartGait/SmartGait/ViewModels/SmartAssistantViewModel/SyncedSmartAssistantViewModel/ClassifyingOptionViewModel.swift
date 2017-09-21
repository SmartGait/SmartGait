//
//  ClassifyingOptionViewModel.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 03/05/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation

class ClassifyingOptionViewModel {
  let title: String
  var selected: Bool

  init(title: String, selected: Bool = false) {
    self.title = title
    self.selected = selected
  }

  func toggle() {
    selected = !selected
  }
}
