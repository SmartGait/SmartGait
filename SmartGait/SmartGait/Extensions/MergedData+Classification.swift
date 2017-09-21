//
//  MergedData+Classification.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 03/06/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import Foundation

extension MergedData {
  mutating func classify(withOptions options: [ClassifyingOption], sensitivity: Float) -> ClassifiableData? {
    let allOptions = ClassifyingOption.options(withType: MData.self, forActivity: iOSData.currentActivity)

    let selectedOptions = allOptions
      .filter { options.contains($0) }

    let classifications = selectedOptions
      .flatMap { try? $0.classify(mergedData: self, sensitivity: sensitivity) }
      .flatMap { $0 }

    let summary = classifications
      .reduce((balanced: 0, imbalanced: 0)) { (res, classification) -> (balanced: Int, imbalanced: Int) in

        let classification = classification.data.dataClassification?.classification
        return classification == .balanced ? (balanced: res.balanced + 1, imbalanced: res.imbalanced)
          : (balanced: res.balanced, imbalanced: res.imbalanced + 1)
    }

    let finalClassification = summary.imbalanced > 0 ? DataClassification(classification: .imbalanced)
      : DataClassification(classification: .balanced)

    let classificationsMapped = classifications
      .flatMap({ (element) -> String? in
        guard let classification = element.data.dataClassification?.classification else {
          return nil
        }
        return "\(classification): \(element.summary)"
      })

    //FIXME: Update when SE-0110 is rollbacked
    classificationSummary = "Final: \(finalClassification.classification.rawValue) - \(zip(selectedOptions, classificationsMapped).map { "\($0.0.rawValue): \($0.1)"})"
    currentActivity = "\(iOSData.currentActivity)"

    print(classificationSummary)
    print(summary)

    self.updateClassification(dataClassification: finalClassification)
    return self
  }
}
