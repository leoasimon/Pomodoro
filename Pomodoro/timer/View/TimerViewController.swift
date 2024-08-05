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
        let view = view as! TimerView
        
        view.clean()
    }
    
    func configure(with cycle: Cycle) {
        let view = view as! TimerView
        
        view.configure(cycle: cycle)
    }
}
