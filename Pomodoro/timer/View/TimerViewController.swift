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
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let view = view as? TimerView else { return }
        
        view.viewModel?.clean()
    }
    
    func configure(with cycle: Cycle) {
        guard let view = view as? TimerView else { return }
        // this can be a nice example of how to handle casting for the other one that I left a comment
        
        let timerViewModel = TimerViewModel(cycle: cycle, delegate: view)
        
        view.viewModel = timerViewModel
    }
}
