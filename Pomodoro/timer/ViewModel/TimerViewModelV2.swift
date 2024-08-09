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
    
    var isRunning: Bool {
        return timer.isValid
    }

    func configure(uiDelegate: TimerUIDelegateV2, cycle: Cycle) {
        self.uiDelegate = uiDelegate
        self.cycle = cycle
        self.timers = cycle.timers
        self.time = currentTimer.duration
        
        self.uiDelegate?.hideUpNext()
        self.uiDelegate?.updateTimer(with: currentTimer)
        self.uiDelegate?.updateTime(with: TimeFormatter.secToTimeStr(for: self.time))
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
        
        // TODO: 1 - Disable control button
        
        // 2 - prepare timer
        uiDelegate.fillTimerProgressBar {
            [weak self] in
            print("Timer is ready to start!")
            
            guard let self = self else { return }
            
            // 3 - start the timer
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.tick), userInfo: nil, repeats: true)
            
            // 4 - update the control btn
            let timerState: TimerState = self.isRunning ? .running : .idle
            let text = self.nextTimer.type == .pause ? "Skip to the break" : "Skip to work"
            uiDelegate.updateControlBtn(for: timerState, with: text)
            
            // 5 - show up next
            uiDelegate.showUpNext(with: self.nextTimer)
        }
    }
    
    func skipToNextTimer() {
        guard let uiDelegate = uiDelegate else {
            return
        }
        
        // TODO: 1 - Disable control button

        // 3 - cancel timer and update time
        timer.invalidate()
        time = 0
        
        // TODO: 4 - animate current timer progress to end
        uiDelegate.skipTimerProgressBar {
            [weak self] in
            
            guard let self = self else { return }
            // 4 - hide up next
            uiDelegate.hideUpNext()
            
            // 5 - Update control btn
            uiDelegate.updateControlBtn(for: .idle, with: "")
            
            // 6 - Update the timer
            self.timerIndex = self.timerIndex == self.timers.count - 1 ? 0 : self.timerIndex + 1
            self.time = self.currentTimer.duration
            
            // 7 - Update timer UI
            uiDelegate.updateTimer(with: self.currentTimer)
            uiDelegate.updateTime(with: TimeFormatter.secToTimeStr(for: self.time))
        }
    }
    
    func jumpToNextTimer() {
        // 1 - reset timer
        timer.invalidate()
        timerIndex = timerIndex == timers.count - 1 ? 0 : timerIndex + 1
        time = currentTimer.duration
        
        // 2 - Update timer ui
        uiDelegate?.updateTimer(with: currentTimer)
        uiDelegate?.updateTime(with: TimeFormatter.secToTimeStr(for: time))
        
        // TODO: 3 - Play sound
        
        // 4 - Start the timer
        startTimer()
    }
    
    @objc func tick() {
        time -= 1
        
        print("tick")
        // Update time in UI
        uiDelegate?.updateTime(with: TimeFormatter.secToTimeStr(for: time))
        
        // Should skip to the next timer (without animation) and run it directly, playing a sound
        if time == 0 {
            jumpToNextTimer()
        }
    }
}
