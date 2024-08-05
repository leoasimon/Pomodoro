//
//  TimerUIDelegate.swift
//  Pomodoro
//
//  Created by Leo on 2024-08-05.
//

import Foundation

enum TimerState {
    case idle, running
}

protocol TimerUIDelegate {
    func showTimer(type: TimerType, duration: Int, rgb: String)
    
    func updateControlBtn(for state: TimerState, text: String, rgb: String)
    
    func showUpNext(with upNext: CycleTimer, rgb: String)
    
    func hideUpNext()
    
    func updateTime(with time: Int)
}
