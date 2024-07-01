//
//  Cycle.swift
//  Pomodoro
//
//  Created by Leo on 2024-06-20.
//

import UIKit

enum TimerType: String, Codable {
    case pause
    case work
}

struct CycleColors: Codable {
    var work: String
    var pause: String
}

struct Cycle: Codable {
    var name: String
    var colors: CycleColors
    var timers: [CycleTimer]
}
