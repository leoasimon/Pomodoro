//
//  TimerViewController.swift
//  Pomodoro
//
//  Created by Leo on 2024-06-23.
//

import UIKit

class TimerViewController: UIViewController {
    
    static var identifier = "TimerView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configure(with cycle: Cycle) {
        guard let view = view as? TimerView else { return }
        
        let timerViewModel = TimerViewModel(timers: cycle.timers, delegate: view)
        
        view.viewModel = timerViewModel
    }
}
