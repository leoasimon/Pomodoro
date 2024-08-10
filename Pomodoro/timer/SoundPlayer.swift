//
//  SoundPlayer.swift
//  Pomodoro
//
//  Created by Leo on 2024-08-05.
//

import Foundation
import AVFoundation

final class SoundPlayer {
    static private let breakSoundUrl = Bundle.main.url(forResource: "break", withExtension: "wav")!

    static private let workSoundUrl = Bundle.main.url(forResource: "work", withExtension: "wav")!

    static private let workAudioPlayer = try? AVAudioPlayer(contentsOf: workSoundUrl)
    static private let breakAudioPlayer = try? AVAudioPlayer(contentsOf: breakSoundUrl)
    
    static func playWorkSound() {
        workAudioPlayer?.prepareToPlay()
        workAudioPlayer?.play()
    }
    
    static func playBreakSound() {
        breakAudioPlayer?.prepareToPlay()
        breakAudioPlayer?.play()
    }
}
