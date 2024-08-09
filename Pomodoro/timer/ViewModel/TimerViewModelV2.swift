//
//  TimerViewModelV2.swift
//  Pomodoro
//
//  Created by Leo on 2024-08-09.
//

import Foundation

class TimerViewModelV2: NSObject {
    var uiDelegate: TimerUIDelegateV2?
    var cycle: Cycle?
    
    var timers: [CycleTimer] = []
    
    var time = 0
    var timerIndex = 0
    
    var timer = Timer()
    
    var currentTimer: CycleTimer {
        return timers[timerIndex]
    }
    
    var nextTimer: CycleTimer {
        let i = timerIndex == timers.count - 1 ? 0 : timerIndex + 1
        return timers[i]
    }
    
    var isRunning: Bool = false
    
    func configure(uiDelegate: TimerUIDelegateV2, cycle: Cycle) {
        self.uiDelegate = uiDelegate
        self.cycle = cycle
        self.timers = cycle.timers
        self.time = currentTimer.duration
        
        self.uiDelegate?.hideUpNext()
        self.uiDelegate?.updateTimer(with: currentTimer)
    }
    
    func handleControlTouched() {
        if isRunning {
            skipToNextTimer()
        } else {
            startTimer()
        }
    }
    
    func startTimer() {
        guard let uiDelegate = uiDelegate else {
            return
        }
        
        // 1 - Disable control button
        uiDelegate.disableControlBtn()
        
        // 2 - prepare timer
        uiDelegate.fillTimerProgressBar {
            [weak self] in
            
            guard let self = self else { return }
            
            // 3 - start the timer
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.tick), userInfo: nil, repeats: true)
            self.isRunning = true
            
            // 4 - update the control btn
            let text = self.nextTimer.type == .pause ? "Skip to the break" : "Skip to work"
            uiDelegate.updateControlBtn(for: .running, with: text)
            
            // 5 - show up next
            uiDelegate.showUpNext(with: self.nextTimer)
        }
    }
    
    func skipToNextTimer() {
        guard let uiDelegate = uiDelegate else {
            return
        }
        
        // 1 - Disable control button
        uiDelegate.disableControlBtn()
        
        let percentage = 1 - Float(time) / Float(currentTimer.duration)
        
        // 3 - cancel timer and update time
        timer.invalidate()
        isRunning = false
        time = 0
        uiDelegate.updateTime(with: self.time, maxTime: self.currentTimer.duration)
        
        // 4 - animate current timer progress to end
        uiDelegate.skipTimerProgressBar(at: percentage) {
            [weak self] in
            
            guard let self = self else { return }
            // 5 - hide up next
            uiDelegate.hideUpNext()
            
            // 6 - Update control btn
            uiDelegate.updateControlBtn(for: .idle, with: "")
            
            // 1 - Update the timer
            self.timerIndex = self.timerIndex == self.timers.count - 1 ? 0 : self.timerIndex + 1
            self.time = self.currentTimer.duration
            
            // 8 - Update timer UI
            uiDelegate.updateTimer(with: self.currentTimer)
        }
    }
    
    func jumpToNextTimer() {
        // 1 - reset timer
        timer.invalidate()
        timerIndex = timerIndex == timers.count - 1 ? 0 : timerIndex + 1
        time = currentTimer.duration
        
        // 2 - Update timer ui
        uiDelegate?.updateTimer(with: currentTimer)
        uiDelegate?.updateTime(with: self.time, maxTime: self.currentTimer.duration)
        
        // TODO: 3 - Play sound
        
        // 4 - Start the timer
        startTimer()
    }
    
    func clean() {
        timer.invalidate()
    }
    
    func pauseTimer() {
        timer.invalidate()
    }
    
    func resumeTimer() {
        if isRunning {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.tick), userInfo: nil, repeats: true)
        }
    }
    
    @objc func tick() {
        time -= 1
        
        // Update time in UI
        uiDelegate?.updateTime(with: self.time, maxTime: self.currentTimer.duration)
        
        // Should skip to the next timer (without animation) and run it directly, playing a sound
        if time == 0 {
            jumpToNextTimer()
        }
    }
}
