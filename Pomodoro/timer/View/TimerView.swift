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
        //        updateTimerLabel(with: TimeFormatter.secToTimeStr(for: viewModel.time))
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

extension TimerView: TimerUIDelegate {
    
    func showTimer(timer: CycleTimer, colors: CycleColors) {
        upNextView.layer.opacity = 0
        timerLabel.text = TimeFormatter.secToTimeStr(for: timer.duration)
        
        switch timer.type {
        case .work:
            let color = UIColor(rgb: colors.work)
            
            controlBtn.setTitle("", for: .normal)
            controlBtn.setTitleColor(color, for: .normal)
            controlBtn.setImage(TimerView.playIcon.withTintColor(UIColor(rgb: colors.work), renderingMode: .alwaysOriginal), for: .normal)
            timerImage.image = TimerView.workImage
            timerBgView.backgroundColor = UIColor(rgb: colors.work)
        case .pause:
            let color = UIColor(rgb: colors.pause)
            
            controlBtn.setTitle("", for: .normal)
            controlBtn.setTitleColor(color, for: .normal)
            controlBtn.setImage(TimerView.playIcon.withTintColor(UIColor(rgb: colors.pause), renderingMode: .alwaysOriginal), for: .normal)
            timerImage.image = TimerView.breakImage
            timerBgView.backgroundColor = UIColor(rgb: colors.pause)
        }
    }
    
    func updateControlBtn(for state: TimerState, text: String, rgb: String) {
        let color = UIColor(rgb: rgb)
        controlBtn.setTitle(text, for: .normal)
        
        switch state {
        case .idle:
            controlBtn.setImage(TimerView.playIcon.withTintColor(color, renderingMode: .alwaysOriginal), for: .normal)
        case .running:
            controlBtn.setImage(TimerView.forwardIcon.withTintColor(color, renderingMode: .alwaysOriginal), for: .normal)
        }
    }
    
    func showUpNext(with upNext: CycleTimer, rgb: String) {
        let color = UIColor(rgb: rgb)
        switch upNext.type {
        case .work:
            let image = TimerView.breakImage.withTintColor(color, renderingMode: .alwaysOriginal)
            upNextImage.image = image
            upNextLabel.text = "\(upNext.name): \(TimeFormatter.secToTimeStr(for: upNext.duration))"
        case .pause:
            let image = TimerView.breakImage.withTintColor(color, renderingMode: .alwaysOriginal)
            upNextImage.image = image
            upNextLabel.text = "\(upNext.name): \(TimeFormatter.secToTimeStr(for: upNext.duration))"
        }
        
        upNextView.layer.opacity = 1
    }
    
    func hideUpNext() {
        
    }
    
    func updateTime(with time: Int) {
        timerLabel.text = TimeFormatter.secToTimeStr(for: time)
    }
    
}
