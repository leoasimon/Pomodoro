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
            uiUpdateDelegate?.updateTime(with: time, maxTime: currentTimer.duration)
        }
    }
    
    var timerIndex = 0
    var timer = Timer()
    
    func configure(cycle: Cycle, uiUpdateDelegate: TimerUIDelegate) {
        self.timers = cycle.timers
        self.colors = cycle.colors
        self.uiUpdateDelegate = uiUpdateDelegate
        
        time = currentTimer.duration
    }
    
    func clean() {
        if timer.isValid {
            timer.invalidate()
        }
    }
    
    @objc func tick() {
        time -= 1
        
        // Should skip to the next timer (without animation) and run it directly, playing a sound
        if time == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                [weak self] in
                
                self?.jumpToNextTimer()
            })
        }
    }
    
    func toggleTimer() {
        if (timer.isValid) {
            skipToNextTimer()
        } else {
            startTimer()
        }
    }
    
    // Play timer init animation and then start it
    func startTimer() {
        assert(uiUpdateDelegate != nil && colors != nil, "This viewModel is missing some important dependancies, did you forget to call it's configure method?")
        guard let uiUpdateDelegate = uiUpdateDelegate else {
            print("This viewModel is missing some important dependancies, did you forget to call it's configure method?")
            return
        }
        
        // 1 - Need some animation before actually starting the timer
        uiUpdateDelegate.startTimer(with: currentTimer, nextTimer: nextTimer) {
            [weak self] uiUpdated in
            
            // TODO: handle case where uiUpdated == false
            guard let self = self else { return }
            
//            self.uiUpdateDelegate?.updateControlBtn(for: .running, type: self.currentTimer.type)
            
            // 2 - Start the timer loop
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.tick), userInfo: nil, repeats: true)
        }
    }
    
    // Will skip directly to the next timer (Play animation)
    // Next timer should be idle, not running
    func skipToNextTimer() {
        assert(uiUpdateDelegate != nil && colors != nil, "This viewModel is missing some important dependancies, did you forget to call it's configure method?")
        guard let uiUpdateDelegate = uiUpdateDelegate else {
            print("This viewModel is missing some important dependancies, did you forget to call it's configure method?")
            return
        }
        
        timer.invalidate()
        let ellapsedTime = Float(time) / Float(currentTimer.duration)
        time = 0
        
        // TODO: handle case where UI update failed
        // 1 - animate the skip
        uiUpdateDelegate.skipToNextTimer(with: currentTimer, nextTimer: nextTimer, at: ellapsedTime) {
            [weak self] uiUpdated in
            
            guard let self = self else { return }
            // self.uiUpdateDelegate?.updateControlBtn(for: .idle, type: self.currentTimer.type)
            
            // 2 - prepare the new timer
            self.timerIndex = self.timerIndex == self.timers.count - 1 ? 0 : self.timerIndex + 1
            self.time = self.currentTimer.duration
            
            // 3 - display the new timer
            self.uiUpdateDelegate?.displayTimer(with: self.currentTimer)
        }
    }
    
    func jumpToNextTimer() {
        // 1 - Stop the timer and move to the next
        timer.invalidate()
        timerIndex = timerIndex == timers.count - 1 ? 0 : timerIndex + 1
        
        // play the sound
        playTimerSound()
        
        // 3 - show the new timer
        uiUpdateDelegate?.displayTimer(with: currentTimer)
        
        // 4 - wait for animation to be done
        uiUpdateDelegate?.startTimer(with: currentTimer, nextTimer: nextTimer) { [weak self] uiUpdated in
            guard let self = self else { return }
            
            // self.uiUpdateDelegate?.updateControlBtn(for: .running, type: self.currentTimer.type)
            
            // 5 - start the new timer
            self.time = self.currentTimer.duration
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.tick), userInfo: nil, repeats: true)
        }
    }
    
    func playTimerSound() {
        let player = currentTimer.type == .work ? workAudioPlayer : breakAudioPlayer
        
        player?.prepareToPlay()
        player?.play()
    }
}
