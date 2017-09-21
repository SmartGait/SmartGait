//
//  ShortWalkInterfaceController+AVSpeechSynthesizer.swift
//  SmartGait
//
//  Created by Francisco Gonçalves on 12/02/2017.
//  Copyright © 2017 Francisco Gonçalves. All rights reserved.
//

import AVFoundation
import WatchKit

protocol PlaySound {
  func play(spokenInstruction: String)
  func play(utterance: AVSpeechUtterance)
}

extension PlaySound {
  func play(spokenInstruction: String) {
    let utterance = AVSpeechUtterance(string: spokenInstruction)
    play(utterance: utterance)
  }

  func play(utterance: AVSpeechUtterance) {
    let watchDelegate = WKExtension.shared().delegate as? ExtensionDelegate
    watchDelegate?.synth.speak(utterance)
  }
}
