//
//  TimerViewModel.swift
//  Pomodoro
//
//  Created by Leo on 2024-07-01.
//

import UIKit

final class TimerViewModel: NSObject {
    let uiUpdateDelegate: TimerViewUIUpdateDelegate
    let timers: [CycleTimer]

    var time = 0 {
        didSet {
            print("Should now update the UI")
            uiUpdateDelegate.updateTimerLabel(with: secToTimeStr(for: time))
        }
    }

    var timerIndex = 0
    var timer = Timer()
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumIntegerDigits = 2
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 0
        return nf
    }()
    
    init(timers: [CycleTimer], delegate: TimerViewUIUpdateDelegate) {
        self.timers = timers
        self.uiUpdateDelegate = delegate
        
        guard let currentTimer = timers.first else {
            print("This cycle has no timers!")
            return
        }
        
        time = currentTimer.duration * 60
    }

    func secToTimeStr(for seconds: Int) -> String {
        let h = seconds / (60 * 60)
        let m = (seconds / 60) % 60
        let s = seconds % 60
        
        let hStr = numberFormatter.string(from: NSNumber(value: h))!
        let mStr = numberFormatter.string(from: NSNumber(value: m))!
        let sStr = numberFormatter.string(from: NSNumber(value: s))!

        print(hStr, mStr, sStr)
        return "\(hStr):\(mStr):\(sStr)"
    }
    
    @objc func tick() {
        time -= 1
    }
    
    func toggleTimer() {
        if (timer.isValid) {
            timer.invalidate()
            uiUpdateDelegate.updateControlBtnTitle(with: "Start")
        } else {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
            uiUpdateDelegate.updateControlBtnTitle(with: "Stop")
        }
    }
}
