//
//  TimerView.swift
//  Pomodoro
//
//  Created by Leo on 2024-07-01.
//

import UIKit

class TimerView: UIView {
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var controlBtn: UIButton!
    @IBOutlet weak var timerImage: UIImageView!
    @IBOutlet weak var timerBgView: UIView!
    @IBOutlet weak var upNextView: UIView!
    @IBOutlet weak var upNextImage: UIImageView!
    @IBOutlet weak var upNextLabel: UILabel!
    
    var viewModel: TimerViewModel? {
        didSet {
            updateTimerLabel(with: TimeFormatter.secToTimeStr(for: viewModel?.time ?? 0))
        }
    }

    @IBAction func toggleTimer(_ sender: Any) {
        viewModel?.toggleTimer()
    }
}

protocol TimerViewUIUpdateDelegate {
    func updateTimerLabel(with newLabel: String)
    func updateControlBtnTitle(text: String, image: UIImage, color: UIColor)
    func updateTimer(image: UIImage, color: UIColor)
    
    func showUpNext(image: UIImage, text: String)
    func hideUpNext()
}

extension TimerView: TimerViewUIUpdateDelegate {
    func updateTimerLabel(with newLabel: String) {
        timerLabel.text = newLabel
    }
    
    func updateControlBtnTitle(text: String, image: UIImage, color: UIColor) {
        controlBtn.setTitle(text, for: .normal)
        controlBtn.setImage(image, for: .normal)
        controlBtn.setTitleColor(color, for: .normal)
    }
    
    func updateTimer(image: UIImage, color: UIColor) {
        timerImage.image = image
        timerBgView.backgroundColor = color
    }
    
    func showUpNext(image: UIImage, text: String) {
        upNextImage.image = image
        upNextLabel.text = text
        upNextView.layer.opacity = 1
    }
    
    func hideUpNext() {
        upNextView.layer.opacity = 0
    }
}
