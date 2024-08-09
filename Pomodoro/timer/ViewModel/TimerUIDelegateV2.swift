//
//  TimerUIDelegateV2.swift
//  Pomodoro
//
//  Created by Leo on 2024-08-09.
//

import Foundation

protocol TimerUIDelegateV2 {
    func fillTimerProgressBar(completion: @escaping (() -> Void))
    func skipTimerProgressBar(completion: @escaping (() -> Void))
    
    func updateTimer(with timer: CycleTimer)
    
    func hideUpNext()
    func showUpNext(with timer: CycleTimer)
    
    func updateControlBtn(for state: TimerState, with text: String)
    
    func updateTime(with time: String)
}
