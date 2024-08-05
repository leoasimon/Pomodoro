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
    
    static let workImage = UIImage(systemName: "laptopcomputer") ?? UIImage(named: "laptopcomputer")!
    static let breakImage = UIImage(systemName: "cup.and.saucer") ?? UIImage(named: "cup.and.saucer")!
    static let forwardIcon = UIImage(systemName: "forward.end") ?? UIImage(named: "forward.end")!
    static let playIcon = UIImage(systemName: "play") ?? UIImage(named: "play")!
    //    https://www.hackingwithswift.com/example-code/language/when-is-it-safe-to-force-unwrap-optionals
    
    let viewModel = TimerViewModel()
    
    @IBAction func toggleTimer(_ sender: Any) {
        viewModel.toggleTimer()
    }
    
    func configure(cycle: Cycle) {
        viewModel.configure(cycle: cycle, uiUpdateDelegate: self)
        updateTimerLabel(with: TimeFormatter.secToTimeStr(for: viewModel.time))
    }
    
    func getImage(for name: String) -> UIImage {
        return UIImage(systemName: name) ?? UIImage(named: name)!
    }
    
    func clean() {
        viewModel.clean()
    }
}

protocol TimerViewUIUpdateDelegate {
    func updateTimerLabel(with newLabel: String)
    func updateControlBtnTitle(text: String, image: String, rgb: String)
    func updateTimer(image: String, rgb: String)
    
    func showUpNext(image: String, tintColor: String, text: String)
    func hideUpNext()
}

extension TimerView: TimerViewUIUpdateDelegate {
    func updateTimerLabel(with newLabel: String) {
        timerLabel.text = newLabel
    }
    
    func updateControlBtnTitle(text: String, image: String, rgb: String) {
        let color = UIColor(rgb: rgb)
        let img = TimerView.playIcon.withTintColor(color, renderingMode: .alwaysOriginal)
        
        controlBtn.setTitle(text, for: .normal)
        controlBtn.setImage(img, for: .normal)
        controlBtn.setTitleColor(color, for: .normal)
    }
    
    func updateTimer(image: String, rgb: String) {
        let color = UIColor(rgb: rgb)
        let image = getImage(for: image).withTintColor(color)
        
        
        timerImage.image = image
        timerBgView.backgroundColor = color
    }
    
    func showUpNext(image: String, tintColor: String, text: String) {
        let color = UIColor(rgb: tintColor)
        let img = getImage(for: image).withTintColor(color, renderingMode: .alwaysOriginal)
        
        upNextImage.image = img
        upNextLabel.text = text
        upNextView.layer.opacity = 1
    }
    
    func hideUpNext() {
        upNextView.layer.opacity = 0
    }
}
