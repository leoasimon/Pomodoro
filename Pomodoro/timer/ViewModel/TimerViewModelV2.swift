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

    func configure(uiDelegate: TimerUIDelegateV2, cycle: Cycle) {
        self.uiDelegate = uiDelegate
        self.cycle = cycle
        
        self.uiDelegate?.hideUpNext()
    }
    
    func handleControlTouched() {
        // start/skip timer
        startTimer()
    }
    
    func startTimer() {
        guard let uiDelegate = uiDelegate else {
            return
        }
        uiDelegate.fillTimerProgressBar {
            print("Timer is ready to start!")
        }
    }
}
