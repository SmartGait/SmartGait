//
//  iPhoneOnlySmartAssistant.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 24/04/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol iPhoneOnlySmartAssistant: SmartAssistant {
}

extension iPhoneOnlySmartAssistant {
  func startSmartAssistant(with startTime: StartTime) {

    startCollectingData(at: startTime)
    setupSmartAssistant()
  }

  private func setupSmartAssistant() {
    startInitialTimer()
      .map(void)
      .do(onNext: { _ in self.enableDataCollection() }) //FIXME: Update when SE-0110 is rollbacked
      .subscribe()
      .addDisposableTo(disposeBag)

    processedData
      .asObservable()
      .map { $0.last as? ProcessedData }
      .unwrap()
      .do(onNext: { (_) in
        print(Date().timeIntervalSince1970)
      })
      .map(classify)
      .unwrap()
      .do(onNext: { (_) in
        print(Date().timeIntervalSince1970)
      })
      .map { $0.data }
      .bind(to: lastClassification)
      .addDisposableTo(disposeBag)
  }

  func classify(processedData: ProcessedData) -> (summary: String, data: ClassifiableData)? {
    return DataClassification.classify(data: processedData, with: .iOSProcessedRest, sensitivity: 0.5)
  }

  private func startInitialTimer() -> Observable<Int> {
    timer.value = .started
    return Observable<Int>
      .timer(startTimerDuration, scheduler:  MainScheduler.instance)
      .do(onNext: handleTimerEnd)
  }

  private func handleTimerEnd(_: Int) {
    timer.value = .ended
  }
}
