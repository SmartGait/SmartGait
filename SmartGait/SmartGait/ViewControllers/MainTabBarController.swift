//
//  MainTabBarController.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 05/05/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()
    self.viewControllers?
      .flatMap { ($0 as? UINavigationController)?.viewControllers.first }
      .filter { $0 is RawSyncedSmartAssistantViewController || $0 is ProcessedSyncedSmartAssistantViewController }
      .forEach { _ = $0.view }
  }
}
