//
//  TimerUIDelegateV2.swift
//  Pomodoro
//
//  Created by Leo on 2024-08-09.
//

import Foundation

protocol TimerUIDelegateV2 {
    func fillTimerProgressBar(completion: @escaping (() -> Void))
    
    func hideUpNext()
    func showUpNext(with timer: CycleTimer)
}
