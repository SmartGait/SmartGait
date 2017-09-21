//
//  RawSyncedSmartAssistantViewController.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 04/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import CoreData
import RxCocoa
import RxSwift
import UIKit
import WatchConnectivity
import AVFoundation
import AudioToolbox
import Watchdog

//swiftlint:disable type_name
class RawSyncedSmartAssistantViewController: UIViewController {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  var audioPlayer: AVAudioPlayer?

  fileprivate var viewModel: SyncedSmartAssistantViewModel<RawData, RawClassificationTaskModel>!

  var watchdog: Watchdog?

  override func viewWillDisappear(_ animated: Bool) {
    UIApplication.shared.isIdleTimerDisabled = false
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    UIApplication.shared.isIdleTimerDisabled = true

    viewModel = SyncedSmartAssistantViewModel(frequency: 100,
                                              classifyingOptionViewModels: defaultClassifyingOptionViewModels())

    setupAudioPlayer()

    viewModel
      .firstClassification
      .do(onNext: { _ in
        self.audioPlayer?.play()
      })
      .subscribe()
      .addDisposableTo(rx_disposeBag)

    viewModel.classifyingOptionViewModels
      .asObservable()
      .observeOn(MainScheduler.instance)
      .bind(to: tableView.rx.items(cellIdentifier: "SyncedSmartAssistantTableViewCell")) { _, viewModel, cell in
        guard let cell = cell as? SyncedSmartAssistantTableViewCell else {
          return
        }

        cell.update(withViewModel: viewModel)
      }
      .addDisposableTo(rx_disposeBag)

    tableView.rx.itemSelected
      .do(onNext: { indexPath in
        let viewModel = self.viewModel.classifyingOptionViewModels.value[indexPath.row]
        viewModel.toggle()
        self.tableView.cellForRow(at: indexPath)?.accessoryType = viewModel.selected ? .checkmark : .none
      })
      .subscribe()
      .addDisposableTo(rx_disposeBag)
  }

  func defaultClassifyingOptionViewModels() -> ClassifyingOptionViewModelsConstructor {
    let enabledOptions = [true, true, true, false, false, false, false, false, false, false, false]

    let allOptions = zip(ClassifyingOption.allOptions(forType: RawData.self), enabledOptions)
      .map { ClassifyingOptionViewModel(title: $0.0.rawValue, selected: $0.1) } //FIXME: Update when SE-0110 is rollbacked

    return Variable(allOptions)
  }

  func setupAudioPlayer() {
    guard let dingSoundPath = Bundle.main.path(forResource: "beep", ofType: "mp3") else {
      return
    }

    let dingSound = URL(fileURLWithPath: dingSoundPath)
    do {
      audioPlayer = try AVAudioPlayer(contentsOf: dingSound)
      audioPlayer?.volume = 1.0
      audioPlayer?.prepareToPlay()
    } catch {
      print("Error getting the audio file")
    }
  }
}

// MARK: - API
extension RawSyncedSmartAssistantViewController {
  func start(data: StartSmartAssistant) {
    watchdog = Watchdog(threshold: 0.2, strictMode: true)
    viewModel.sensitivity = data.sensitivity
    viewModel.startSmartAssistant(with: data.startTime)
  }

  func handle(processedData: RawData, replyHandler: @escaping (([String : Any]) -> Void)) {
    viewModel.handle(processedData: processedData, replyHandler: replyHandler)
  }

  func resume() {
    viewModel.resume()
  }

  func stop() {
    viewModel.stop()
  }

  func updateSensivity(data: StartSmartAssistant) {
    viewModel.sensitivity = data.sensitivity
  }
}
