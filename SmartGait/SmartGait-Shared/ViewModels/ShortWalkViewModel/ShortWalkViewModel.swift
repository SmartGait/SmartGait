//
//  ShortWalkViewModel.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 03/02/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//
import Foundation
import RxSwift
import RxCocoa
import CoreMotion
import RxCoreMotion

class ShortWalkViewModel {
  private let identifier: String
  let numberOfStepsPerLeg: Int
  let restDuration: TimeInterval

  private let startDate = Date()
  private var endDate = Date()
  private let pedometerManager = CMPedometer()

  let startTimerDuration: TimeInterval = 5

  var startTime: StartTime

  let currentStep = Variable<LinkedListNode<StepViewModel>?>(nil)
  let stepViewModels = Variable<LinkedList<StepViewModel>>(LinkedList())

  init(identifier: String,
       numberOfStepsPerLeg: Int,
       restDuration: TimeInterval,
       startTime: StartTime?) {

    self.identifier = identifier
    self.numberOfStepsPerLeg = numberOfStepsPerLeg
    self.restDuration = restDuration
    self.startTime = startTime ?? StartTime(time: 0)

    let steps = [StepViewModel(identifier: "walking.outbound",
                               description: String
                                .localizedStringWithFormat(
                                  NSLocalizedString("WalkingOutbound", comment: ""), numberOfStepsPerLeg),
                               until: takeSteps(until: numberOfStepsPerLeg, or: 1.5)),
                 StepViewModel(identifier: "walking.return",
                               description: String
                                .localizedStringWithFormat(
                                  NSLocalizedString("WalkingReturn", comment: ""), numberOfStepsPerLeg),
                  until: takeSteps(until: numberOfStepsPerLeg, or: 1.5)),
                 StepViewModel(identifier: "rest",
                               description: String
                                .localizedStringWithFormat(
                                  NSLocalizedString("Rest", comment: ""), Int(restDuration)),
                  until: rest(until: restDuration))]

    stepViewModels.value.append(steps)

    currentStep.value = stepViewModels.value.first
  }

  func finish() -> Task {
    //swiftlint:disable force_cast
    return Task(
      identifier: identifier,
      startDate: startDate,
      endDate: endDate,
      steps: stepViewModels.value.flatMap { $0.step.value })
  }

  /**
   The number of steps the user should be asked to take in each leg of the
   walking task step.

   The step finishes when the number of steps have been completed,
   or after `1.5 * numberOfStepsPerLeg` seconds, whichever comes first.
   */
  fileprivate func takeSteps(until numberOfStepsPerLeg: Int, or time: Double) -> Observable<Bool> {
    _ = pedometerManager
      .rx.pedometer
      .debug()
      .do(onNext: { log.warning(($0.numberOfSteps.intValue < self.numberOfStepsPerLeg * 2)) })
      .skipWhile { $0.numberOfSteps.intValue < self.numberOfStepsPerLeg * 2 }
      .map { _ in true }
      .shareReplayLatestWhileConnected()

    let timePassed = Observable<Int>
      .timer(1.5 * Double(numberOfStepsPerLeg), scheduler: MainScheduler.instance)
      .debug()
      .map { _ in true }
      .shareReplayLatestWhileConnected()

    //return Observable.of(stepsTaken, timePassed).merge()
    return timePassed
  }

  fileprivate func rest(until restDuration: TimeInterval) -> Observable<Bool> {
    return Observable<Int>.timer(restDuration, scheduler: MainScheduler.instance)
      .map { _ in true }
      .shareReplayLatestWhileConnected()
  }

  func nextStep() {
    currentStep.value = currentStep.value?.next
  }
}
