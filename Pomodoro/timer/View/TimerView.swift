//
//  TimerView.swift
//  Pomodoro
//
//  Created by Leo on 2024-07-01.
//

import UIKit

class TimerView: UIView {
    @IBOutlet weak var timerLabel: UILabel?
    @IBOutlet weak var controlBtn: UIButton!
    
    var viewModel: TimerViewModel? {
        didSet {
            updateTimerLabel(with: viewModel?.secToTimeStr(for: viewModel?.time ?? 0) ?? "")
        }
    }

    @IBAction func toggleTimer(_ sender: Any) {
        viewModel?.toggleTimer()
    }
}

protocol TimerViewUIUpdateDelegate {
    func updateTimerLabel(with newLabel: String)
    func updateControlBtnTitle(with newTitle: String)
}

extension TimerView: TimerViewUIUpdateDelegate {
    func updateTimerLabel(with newLabel: String) {
        print("About to update label with \(newLabel)")
        timerLabel?.text = newLabel
    }
    
    func updateControlBtnTitle(with newTitle: String) {
//        controlBtn.titleLabel?.text = newTitle
        controlBtn.setTitle(newTitle, for: .normal)
    }
}
