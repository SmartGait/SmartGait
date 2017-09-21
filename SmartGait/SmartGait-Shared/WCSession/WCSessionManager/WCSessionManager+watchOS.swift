//
//  WCSessionManager+watchOS.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 11/02/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import Result
import RxSwift
import WatchConnectivity

extension WCSessionManager {
  func setupObservables() {
    session.rx
      .didFinishFileTransfer
      .do(onNext: { (result) in
        switch result {
        case .success(let filetransfer):
          self.delete(fileTransfer: filetransfer)
        case .failure(let error):
          log.error("Error transfering file \(error)")
        }
             })
      .subscribe()
      .addDisposableTo(disposeBag)

    session.rx
      .reachabilityDidChange
      .do(onNext: { (isReachable) in
        log.warning("reach \(isReachable)")
      })
      .subscribe()
      .addDisposableTo(disposeBag)
  }

  private func delete(fileTransfer: WCSessionFileTransfer) {
    guard !fileTransfer.isTransferring else {
      log.error("Still transfering")
      return
    }

    do {
      try deleteFile(fileURL: fileTransfer.file.fileURL)
    } catch let error {
      log.error(error)
    }

  }

  private func deleteFile(fileURL: URL) throws {
    let fileManager = FileManager.default

    guard fileManager.fileExists(atPath: fileURL.path) else {
      throw "File does not exist"
    }

    try fileManager.removeItem(at: fileURL)
  }

}
