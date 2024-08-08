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
    
    private let timerProgressPlaceholder = CAShapeLayer()
    let timerProgress = CAShapeLayer()
    
    var workColor = UIColor()
    var breakColor = UIColor()
    
    var skipToWorkConstraint: NSLayoutConstraint?
    var playConstraint: NSLayoutConstraint?
    var skipToBreakConstraint: NSLayoutConstraint?
    
    static let workImage = UIImage(systemName: "laptopcomputer") ?? UIImage(named: "laptopcomputer")!
    static let breakImage = UIImage(systemName: "cup.and.saucer") ?? UIImage(named: "cup.and.saucer")!
    static let forwardIcon = UIImage(systemName: "forward.end") ?? UIImage(named: "forward.end")!
    static let playIcon = UIImage(systemName: "play") ?? UIImage(named: "play")!
    //    https://www.hackingwithswift.com/example-code/language/when-is-it-safe-to-force-unwrap-optionals
    
    var upNextWorkImage: UIImage?
    var upNextBreakImage: UIImage?
    
    let viewModel = TimerViewModel()
    var animationDelegate: TimerViewAnimationProtocol?
    
    @IBAction func toggleTimer(_ sender: Any) {
        viewModel.toggleTimer()
    }
    
    func configure(cycle: Cycle) {
        viewModel.configure(cycle: cycle, uiUpdateDelegate: self)

        // TODO: Find a way to not reinitialize those colors
        workColor = UIColor(rgb: cycle.colors.work)
        breakColor = UIColor(rgb: cycle.colors.pause)
        
        upNextWorkImage = TimerView.workImage.withTintColor(workColor, renderingMode: .alwaysOriginal)
        upNextBreakImage = TimerView.breakImage.withTintColor(breakColor, renderingMode: .alwaysOriginal)
        
        animationDelegate = TimerViewAnimationDelegate(for: self, colors: cycle.colors)
        
        // TODO: Move this and the outlets to the delegate
        skipToBreakModelLabel.removeFromSuperview()
        skipToWorkModelLabel.removeFromSuperview()
        
        // Build initial UI
        // let color = UIColor(rgb: cycle.colors.work)
        
        // 1 - Control Button
        controlBtn.setTitle("", for: .normal)
        // controlBtn.titleLabel?.layer.opacity = 0
        // controlBtn.titleLabel?.lineBreakMode = .byTruncatingTail
        
        // controlBtn.setImage(TimerView.playIcon.withTintColor(color, renderingMode: .alwaysOriginal), for: .normal)
        controlBtn.setImage(TimerView.playIcon, for: .normal)
        // controlBtn.setTitleColor(color, for: .normal)
        controlBtn.setTitle("", for: .normal)
        
        // Timer Progress Circle
        buildTimerProgress()
        
        // Timer
        guard let firstTimer = cycle.timers.first else { return }
        displayTimer(with: firstTimer)
    }
    
    override func layoutSubviews() {
        layer.addSublayer(timerProgressPlaceholder)
        layer.addSublayer(timerProgress)
        super.layoutSubviews()
    }
    
    func clean() {
        viewModel.clean()
    }
    
    private func buildTimerProgress() {
        let radius = CGFloat(120)
        let center = CGPoint(x: timerBgView.bounds.midX, y: timerBgView.bounds.midY)
        let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi * 1.5), clockwise: true)
        
        timerProgress.path = circlePath.cgPath
        timerProgressPlaceholder.path = circlePath.cgPath
        
        timerProgress.fillColor = UIColor.clear.cgColor
        timerProgressPlaceholder.fillColor = UIColor.clear.cgColor
        
        timerProgress.strokeColor = UIColor.white.cgColor
        timerProgressPlaceholder.strokeColor = UIColor(white: 1, alpha: 0.3).cgColor
        
        timerProgress.lineWidth = 12.0
        timerProgressPlaceholder.lineWidth = 12.0
        
        timerProgressPlaceholder.strokeStart = 0
        timerProgressPlaceholder.strokeEnd = 1
        
        timerProgress.strokeStart = 1
        timerProgress.strokeEnd = 1
        
        layer.addSublayer(timerProgressPlaceholder)
    }

    private func showUpNext() {
        upNextView.layer.opacity = 1
    }
    
    private func hideUpNext() {
        upNextView.layer.opacity = 0
    }
    
    private func changeBtnColor(with color: UIColor) {
        for btnState in [UIButton.State.normal, UIButton.State.highlighted] {
            controlBtn.setTitleColor(color, for: btnState)
        }
    }
    
    private func updateUpNext(for type: TimerType) {
        if type == .work {
            let image = upNextBreakImage ?? TimerView.breakImage.withTintColor(breakColor)
            self.upNextImage.image = image
        } else {
            let image = upNextWorkImage ?? TimerView.workImage.withTintColor(workColor)
            self.upNextImage.image = image
        }
    }
}

extension TimerView: TimerUIDelegate {
    // TODO: refacto all the duplicated code here
    func startTimer(with timer: CycleTimer, nextTimer: CycleTimer, completion: @escaping (_ uiUpdated: Bool) -> Void) {
        controlBtn.isEnabled = false
        updateUpNext(for: timer.type)
        
        animationDelegate?.animateTimerStart(timerType: timer.type) { [weak self] in
            print("All done with the animation!")

            guard let self = self else {
                return completion(false)
            }
            
            self.timerProgress.strokeStart = 0
            self.timerProgress.strokeEnd = 1
            self.showUpNext()
            
            let text = nextTimer.type == .pause ? "Skip to the break" : "Skip to work"
            self.controlBtn.isEnabled = true
            self.controlBtn.setImage(TimerView.forwardIcon, for: .normal)
            self.controlBtn.setTitle(text, for: .normal)
            
            completion(true)
        }
    }
    
    func skipToNextTimer(with timer: CycleTimer, nextTimer: CycleTimer, at ellapsedTime: Float, completion: @escaping (_ uiUpdated: Bool) -> Void) {
        timerLabel.text = TimeFormatter.secToTimeStr(for: 0)
        
        self.controlBtn.isEnabled = false
        self.hideUpNext()
        
        animationDelegate?.animateTimerSkip(timerType: nextTimer.type, at: ellapsedTime) { [weak self] in
            print("All done with the animation!")

            guard let self = self else {
                return completion(false)
            }
            
            // lock the timer progress bar
            self.timerProgress.strokeStart = 1
            self.timerProgress.strokeEnd = 1
            
            self.displayTimer(with: nextTimer)
            
            self.controlBtn.isEnabled = true
            self.controlBtn.setImage(TimerView.playIcon, for: .normal)
            self.controlBtn.setTitle("", for: .normal)
            
            completion(true)
        }
    }

    func updateTime(with time: Int, maxTime: Int) {
        timerLabel.text = TimeFormatter.secToTimeStr(for: time)
        timerProgress.strokeStart = 1 - CGFloat(time) / CGFloat(maxTime)
        print(timerProgress.strokeStart)
    }
    
    func displayTimer(with timer: CycleTimer) {
        let color = timer.type == .work ? workColor : breakColor
        
        timerLabel.text = TimeFormatter.secToTimeStr(for: timer.duration)
        timerBgView.backgroundColor = color
        timerImage.image = timer.type == .work ? TimerView.workImage : TimerView.breakImage
        upNextImage.image = timer.type == .work ? TimerView.breakImage : TimerView.workImage

        timerProgress.strokeStart = 1
        timerProgress.strokeEnd = 1
        
        // changeBtnColor(with: color)
        updateUpNext(for: timer.type)
    }
    
    func updateControlBtn(for state: TimerState, type: TimerType) {
        let color = type == .work ? workColor : breakColor
        
        var text = ""
        if state == .running {
            text = type == .work ? "Skip to the break" : "Skip to work"
        }
        
        controlBtn.setTitle(text, for: .normal)
        controlBtn.setTitle(text, for: .highlighted)
        
        let icon = state == .idle ? TimerView.playIcon : TimerView.forwardIcon
        controlBtn.setImage(icon.withTintColor(color, renderingMode: .alwaysOriginal), for: .normal)
    }

}

