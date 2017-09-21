//
//  URL+JSON.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 26/01/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation

extension URL {
  func json() throws -> NSString {
    return try NSString(contentsOf: self, encoding: String.Encoding.utf8.rawValue)
  }
}
