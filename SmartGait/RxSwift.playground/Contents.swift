//: Playground - noun: a place where people can play

import UIKit
import RxSwift
import RxCocoa
import PlaygroundSupport
import GLKit

PlaygroundPage.current.needsIndefiniteExecution = true

let values = [1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3,
              4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6,
              7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8].map { Observable.just($0) }
var observableData = Observable.concat(values)

var until: Observable<Bool> {
  return Observable<Int>
    .timer(1, scheduler: MainScheduler.instance)
    .map { _ in true }
}

let reducedData = observableData.scan([], accumulator: { (result, value) -> [Int] in
  var result = result
  result.append(value)
  return result
})

reducedData
  .delay(0.3, scheduler: MainScheduler.instance)
  .takeUntil(until)
  .takeLast(2)
  .flatMapLatest({ (data) -> Observable<[Int]> in
    print(data)
    return .just(data)
  })
  .subscribe { (event) in
    print(event)
  }

// (x: 0.14483907827346387, y: 0.60879332540228326, z: 0.75582140623471683, w: 0.19268194058576868))

//x: Float,_ y: Float,_ z: Float,_ w: Float)
let quaternion = GLKQuaternion(q: (0.14483907827346387, 0.60879332540228326, 0.75582140623471683, 0.19268194058576868))

let conjugatedQuaternion = GLKQuaternionConjugate(quaternion)

let acceleration = GLKVector3(v: (-0.05898316949605942, -0.9743823409080505, -0.21702538430690765))

let accelerationRotated = GLKQuaternionRotateVector3(conjugatedQuaternion, acceleration)

accelerationRotated.x
accelerationRotated.y
accelerationRotated.z
