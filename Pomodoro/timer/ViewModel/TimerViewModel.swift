//
//  TimerViewModel.swift
//  Pomodoro
//
//  Created by Leo on 2024-07-01.
//

import AVFoundation

final class TimerViewModel: NSObject {
    var uiUpdateDelegate: TimerUIDelegate?
    var timers: [CycleTimer] = []
    var colors: CycleColors?
    
    var breakAudioPlayer: AVAudioPlayer?
    var workAudioPlayer: AVAudioPlayer?
    
    var currentTimer: CycleTimer {
        return timers[timerIndex]
    }
    
    var nextTimer: CycleTimer {
        let i = timerIndex == timers.count - 1 ? 0 : timerIndex + 1
        return timers[i]
    }
    
    var time = 0 {
        didSet {
            uiUpdateDelegate?.updateTime(with: time)
            if time == 0 {
                skipToNextTimer()
                //                playTimerSound()
                startTimer()
            }
        }
    }
    
    var timerIndex = 0
    var timer = Timer()
    
    func configure(cycle: Cycle, uiUpdateDelegate: TimerUIDelegate) {
        self.timers = cycle.timers
        self.colors = cycle.colors
        self.uiUpdateDelegate = uiUpdateDelegate
        
        time = currentTimer.duration
        
        uiUpdateDelegate.showTimer(type: currentTimer.type, duration: currentTimer.duration, rgb: cycle.colors.work)
        uiUpdateDelegate.hideUpNext()
    }
    
    func clean() {
        if timer.isValid {
            timer.invalidate()
        }
    }
    
    @objc func tick() {
        time -= 1
    }
    
    func toggleTimer() {
        if (timer.isValid) {
            skipToNextTimer()
        } else {
            startTimer()
        }
    }
    
    func startTimer() {
        assert(uiUpdateDelegate != nil && colors != nil, "This viewModel is missing some important dependancies, did you forget to call it's configure method?")
        guard let uiUpdateDelegate = uiUpdateDelegate, let colors = colors else {
            print("This viewModel is missing some important dependancies, did you forget to call it's configure method?")
            return
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        
        
        switch currentTimer.type {
        case .work:
            let color = colors.work
            let upNextColor = colors.pause
            let text = "Skip to the break"
            
            uiUpdateDelegate.showTimer(type: .work, duration: currentTimer.duration, rgb: colors.work)
            uiUpdateDelegate.updateControlBtn(for: .running, text: text, rgb: color)
            uiUpdateDelegate.showUpNext(with: nextTimer, rgb: upNextColor)
        case .pause:
            let color = colors.pause
            let upNextColor = colors.work
            let text = "Skip to work"
            
            uiUpdateDelegate.showTimer(type: .pause, duration: currentTimer.duration, rgb: colors.pause)
            uiUpdateDelegate.updateControlBtn(for: .running, text: text, rgb: color)
            uiUpdateDelegate.showUpNext(with: nextTimer, rgb: upNextColor)
        }
    }
    
    func skipToNextTimer() {
        assert(uiUpdateDelegate != nil && colors != nil, "This viewModel is missing some important dependancies, did you forget to call it's configure method?")
        guard let uiUpdateDelegate = uiUpdateDelegate, let colors = colors else {
            print("This viewModel is missing some important dependancies, did you forget to call it's configure method?")
            return
        }
        
        timerIndex = timerIndex == timers.count - 1 ? 0 : timerIndex + 1
        
        timer.invalidate()
        
        let color = currentTimer.type == .work ? colors.work : colors.pause
        
        time = currentTimer.duration
        
        uiUpdateDelegate.updateControlBtn(for: .idle, text: "", rgb: color)
        uiUpdateDelegate.showTimer(type: currentTimer.type, duration: currentTimer.duration, rgb: color)
        uiUpdateDelegate.hideUpNext()
    }
    
    func playTimerSound() {
        let player = currentTimer.type == .work ? workAudioPlayer : breakAudioPlayer
        
        player?.prepareToPlay()
        player?.play()
    }
}
