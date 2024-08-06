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
    
    @IBOutlet weak var skipToBreakModelLabel: UIButton!
    @IBOutlet weak var skipToWorkModelLabel: UIButton!
    
    var skipToWorkConstraint: NSLayoutConstraint?
    var playConstraint: NSLayoutConstraint?
    var skipToBreakConstraint: NSLayoutConstraint?
    
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
        
        let skipToWorkTargetWidth = skipToWorkModelLabel.frame.width + 32
        let skipToBreakTargetWidth = skipToBreakModelLabel.frame.width + 32
        let playTargetWidth = controlBtn.frame.width
        
        skipToBreakModelLabel.removeFromSuperview()
        skipToWorkModelLabel.removeFromSuperview()
        
        controlBtn.setTitle("", for: .normal)
        controlBtn.titleLabel?.layer.opacity = 0
        controlBtn.titleLabel?.lineBreakMode = .byTruncatingTail
        controlBtn.translatesAutoresizingMaskIntoConstraints = false
        
        playConstraint = controlBtn.widthAnchor.constraint(equalToConstant: playTargetWidth)
        skipToWorkConstraint = controlBtn.widthAnchor.constraint(equalToConstant: skipToWorkTargetWidth)
        skipToBreakConstraint = controlBtn.widthAnchor.constraint(equalToConstant: skipToBreakTargetWidth)
        playConstraint?.isActive = true
        
        guard let playConstraint = playConstraint else {
            return
        }
        
        NSLayoutConstraint.activate([
            playConstraint,
            controlBtn.heightAnchor.constraint(equalToConstant: controlBtn.frame.height)
        ])
    }
    
    func getImage(for name: String) -> UIImage {
        return UIImage(systemName: name) ?? UIImage(named: name)!
    }
    
    func clean() {
        viewModel.clean()
    }
}

extension TimerView: TimerUIDelegate {
    func showTimer(type: TimerType, duration: Int, rgb: String) {
        let color = UIColor(rgb: rgb)
        timerLabel.text = TimeFormatter.secToTimeStr(for: duration)
        
        timerBgView.backgroundColor = UIColor(rgb: rgb)
        
        controlBtn.setImage(TimerView.playIcon.withTintColor(color, renderingMode: .alwaysOriginal), for: .normal)
        controlBtn.setTitleColor(color, for: .normal)
        controlBtn.setTitle("", for: .normal)
        
        timerImage.image = type == .work ? TimerView.workImage : TimerView.breakImage
        upNextImage.image = type == .work ? TimerView.breakImage : TimerView.workImage
    }
    
    private func changeBtnColor(with color: UIColor) {
        for btnState in [UIButton.State.normal, UIButton.State.highlighted] {
            controlBtn.setTitleColor(color, for: btnState)
        }
    }
    
    func updateControlBtn(for state: TimerState, text: String, rgb: String) {
        let color = UIColor(rgb: rgb)
        
        changeBtnColor(with: color)
        controlBtn.setTitle(text, for: .normal)
        controlBtn.setTitle(text, for: .highlighted)

        switch state {
        case .idle:
            controlBtn.setImage(TimerView.playIcon.withTintColor(color, renderingMode: .alwaysOriginal), for: .normal)
        case .running:
            controlBtn.setImage(TimerView.forwardIcon.withTintColor(color, renderingMode: .alwaysOriginal), for: .normal)
        }
        
        if text == "" {
            animateControlBtnCollapse()
        } else {
            animateControlBtnExpand(with: text)
        }
    }
    
    func animateControlBtnExpand(with text: String) {
        playConstraint?.isActive = false
        
        let constraint = text == "Skip to work" ? self.skipToWorkConstraint : self.skipToBreakConstraint
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: { [weak self] in
            self?.controlBtn.titleLabel?.layer.opacity = 1
            constraint?.isActive = true
            self?.layoutIfNeeded()
        })
    }
    
    func animateControlBtnCollapse() {
        skipToWorkConstraint?.isActive = false
        skipToBreakConstraint?.isActive = false
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: { [weak self] in
            self?.controlBtn.titleLabel?.layer.opacity = 0
            self?.playConstraint?.isActive = true
            self?.layoutIfNeeded()
        })
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
        upNextView.layer.opacity = 0
    }
    
    func updateTime(with time: Int) {
        timerLabel.text = TimeFormatter.secToTimeStr(for: time)
    }
    
}

