//
//  TimerViewModel.swift
//  Pomodoro
//
//  Created by Leo on 2024-07-01.
//

import AVFoundation

final class TimerViewModel: NSObject {
    var uiUpdateDelegate: TimerViewUIUpdateDelegate?
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
            uiUpdateDelegate?.updateTimerLabel(with: TimeFormatter.secToTimeStr(for: time))
            if time == 0 {
                skipToNextTimer()
                playTimerSound()
                startTimer()
            }
        }
    }
    
    var timerIndex = 0
    var timer = Timer()
    
    func configure(cycle: Cycle, uiUpdateDelegate: TimerViewUIUpdateDelegate) {
        self.timers = cycle.timers
        self.colors = cycle.colors
        self.uiUpdateDelegate = uiUpdateDelegate
        
        time = currentTimer.duration
        
        updateTimerUI()
        
        uiUpdateDelegate.updateControlBtnTitle(text: "", image: "play", rgb: cycle.colors.work)
        
        uiUpdateDelegate.updateControlBtnTitle(text: "", image: "play", rgb: cycle.colors.work)
        let breakSoundUrl = Bundle.main.url(forResource: "break", withExtension: "wav")!
        
        let workSoundUrl = Bundle.main.url(forResource: "work", withExtension: "wav")!
        
        workAudioPlayer = try? AVAudioPlayer(contentsOf: workSoundUrl)
        breakAudioPlayer = try? AVAudioPlayer(contentsOf: breakSoundUrl)
    }
    
    func clean() {
        if timer.isValid {
            timer.invalidate()
        }
    }
    
    func updateTimerUI() {
        assert(uiUpdateDelegate != nil && colors != nil, "This viewModel is missing some important dependancies, did you forget to call it's configure method?")
        guard let uiUpdateDelegate = uiUpdateDelegate, let colors = colors else {
            print("This viewModel is missing some important dependancies, did you forget to call it's configure method?")
            return
        }
        
        uiUpdateDelegate.hideUpNext()
        if (currentTimer.type == .work) {
            uiUpdateDelegate.updateTimer(image: "laptopcomputer", rgb: colors.work)
        } else {
            uiUpdateDelegate.updateTimer(image: "cup.and.saucer", rgb: colors.pause)
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
        
        let buttonText = currentTimer.type == .work ? "Skip to the break" : "Skip to work"
        let color = currentTimer.type == .work ? colors.work : colors.pause
        uiUpdateDelegate.updateControlBtnTitle(text: buttonText, image: "forward.end", rgb: color)
        
        let timerText = "\(nextTimer.name): \(TimeFormatter.secToTimeStr(for: nextTimer.duration))"
        let image = nextTimer.type == .work ? "laptopcomputer" : "cup.and.saucer"
        let tintColor = nextTimer.type == .work ? colors.work : colors.pause
        uiUpdateDelegate.showUpNext(image: image, tintColor: tintColor, text: timerText)
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
        
        uiUpdateDelegate.updateControlBtnTitle(text: "", image: "play", rgb: color)
        time = currentTimer.duration
        updateTimerUI()
    }
    
    func playTimerSound() {
        let player = currentTimer.type == .work ? workAudioPlayer : breakAudioPlayer
        
        player?.prepareToPlay()
        player?.play()
    }
}
