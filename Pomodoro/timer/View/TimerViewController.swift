//
//  TimerViewController.swift
//  Pomodoro
//
//  Created by Leo on 2024-08-09.
//

import UIKit

class TimerViewController: UIViewController {
    let timerViewModel = TimerViewModel()
    
    static let identifier = "TimerViewController"
    
    func configure(with cycle: Cycle) {
        guard let view = view as? TimerView else { return }
        
        view.configure(colors: cycle.colors)
        timerViewModel.configure(uiDelegate: view, cycle: cycle)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timerViewModel.clean()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        // TODO: Make this button bigger
        let closeBtn = UIBarButtonItem(image: UIImage(systemName: "xmark.circle")?.withTintColor(.white, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(quitCycle))
        navigationItem.leftBarButtonItem = closeBtn
    }
    
    @IBAction func handleTimerBtn(_ sender: Any) {
        self.timerViewModel.handleControlTouched()
    }
    
    @objc func quitCycle() {
        timerViewModel.pauseTimer()
        let ac = UIAlertController(title: "Quit your session?", message: "This will stop the timer and redirect you to the cycle selection", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {
            [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            [weak self] _ in
            self?.timerViewModel.resumeTimer()
        }))
        
        present(ac, animated: true)
    }
}
