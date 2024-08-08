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
    func startTimer(with timer: CycleTimer, nextTimer: CycleTimer, completion: @escaping (_ uiUpdated: Bool) -> Void)
    func skipToNextTimer(with timer: CycleTimer, nextTimer: CycleTimer, at ellapsedTime: Float, completion: @escaping (_ uiUpdated: Bool) -> Void)
    func displayTimer(with timer: CycleTimer)
    func updateTime(with time: Int, maxTime: Int)
    func updateControlBtn(for state: TimerState, type: TimerType)
}
