//
//  TimerViewModel.swift
//  Pomodoro
//
//  Created by Leo on 2024-07-01.
//

import UIKit

final class TimerViewModel: NSObject {
    
    static let workImage = UIImage(systemName: "laptopcomputer")!
    static let breakImage = UIImage(systemName: "cup.and.saucer")!
    static let forwardIcon = UIImage(systemName: "forward.end")!
    static let playIcon = UIImage(systemName: "play")!
    
    let uiUpdateDelegate: TimerViewUIUpdateDelegate
    let timers: [CycleTimer]
    let colors: CycleColors

    var currentTimer: CycleTimer {
        return timers[timerIndex]
    }

    var time = 0 {
        didSet {
            uiUpdateDelegate.updateTimerLabel(with: secToTimeStr(for: time))
            if time == 0 {
                skipToNextTimer()
                startTimer()
            }
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
    
    init(cycle: Cycle, delegate: TimerViewUIUpdateDelegate) {
        self.timers = cycle.timers
        self.colors = cycle.colors
        self.uiUpdateDelegate = delegate
        
        super.init()
        
        time = currentTimer.duration
        
        updateTimerUI()
        
        let color = UIColor(rgb: colors.work)
        let img = TimerViewModel.playIcon.withTintColor(color, renderingMode: .alwaysOriginal)
        uiUpdateDelegate.updateControlBtnTitle(text: "", image: img, color: UIColor(rgb: colors.work))
    }
    
    func clean() {
        if timer.isValid {
            timer.invalidate()
        }
    }
    
    func updateTimerUI() {
        uiUpdateDelegate.hideUpNext()
        if (currentTimer.type == .work) {
            let color = colors.work
            uiUpdateDelegate.updateTimer(image: TimerViewModel.workImage, color: UIColor(rgb: color))
            
            let upNextText = "Break: \(secToTimeStr(for: time))"
            let image = TimerViewModel.breakImage.withTintColor(UIColor(rgb: colors.pause), renderingMode: .alwaysOriginal)
            uiUpdateDelegate.setUpNext(image: image, text: upNextText)
        } else {
            let color = colors.pause
            uiUpdateDelegate.updateTimer(image: TimerViewModel.breakImage, color: UIColor(rgb: color))
            
            let upNextText = "Work: \(secToTimeStr(for: time))"
            let image = TimerViewModel.workImage.withTintColor(UIColor(rgb: colors.work), renderingMode: .alwaysOriginal)
            uiUpdateDelegate.setUpNext(image: image, text: upNextText)
        }
    }

    func secToTimeStr(for seconds: Int) -> String {
        let h = seconds / (60 * 60)
        let m = (seconds / 60) % 60
        let s = seconds % 60
        
        let hStr = numberFormatter.string(from: NSNumber(value: h))!
        let mStr = numberFormatter.string(from: NSNumber(value: m))!
        let sStr = numberFormatter.string(from: NSNumber(value: s))!

        return "\(hStr):\(mStr):\(sStr)"
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
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        
        let buttonText = currentTimer.type == .work ? "Skip to the break" : "Skip to work"
        let color = currentTimer.type == .work ? UIColor(rgb: colors.work) : UIColor(rgb: colors.pause)
        let img = TimerViewModel.forwardIcon.withTintColor(color, renderingMode: .alwaysOriginal)
        uiUpdateDelegate.updateControlBtnTitle(text: buttonText, image: img, color: color)
        
        uiUpdateDelegate.showUpNext()
    }
    
    func skipToNextTimer() {
        timerIndex = timerIndex == timers.count - 1 ? 0 : timerIndex + 1
        
        timer.invalidate()
        
        let color = currentTimer.type == .work ? UIColor(rgb: colors.work) : UIColor(rgb: colors.pause)
        let img = TimerViewModel.playIcon.withTintColor(color, renderingMode: .alwaysOriginal)
        
        uiUpdateDelegate.updateControlBtnTitle(text: "", image: img, color: color)
        time = currentTimer.duration
        updateTimerUI()
    }
}
