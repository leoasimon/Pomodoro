//
//  TimerV2View.swift
//  Pomodoro
//
//  Created by Leo on 2024-08-09.
//

import UIKit

class TimerViewV2: UIView, TimerUIDelegateV2 {
    
    @IBOutlet weak var timerImageView: UIImageView!
    
    @IBOutlet weak var upNextLabel: UILabel!
    @IBOutlet weak var upNextImage: UIImageView!
    @IBOutlet weak var upNextView: UIView!
    
    @IBOutlet weak var controlBtn: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    var colors = ["work": UIColor.blue, "pause": UIColor.orange]
    
    private let timerProgressPlaceholder = CAShapeLayer()
    let timerProgress = CAShapeLayer()
    
    private let timerAnimationDuration = 0.7
    let initTimerAnimation = CABasicAnimation(keyPath: "strokeStart")
    let skipTimerAnimation = CABasicAnimation(keyPath: "strokeStart")
    
    var buttonColor = UIColor()
    
    override func layoutSubviews() {
        layer.addSublayer(timerProgressPlaceholder)
        layer.addSublayer(timerProgress)
        super.layoutSubviews()
    }
    
    func configure(colors: CycleColors) {
        self.colors["work"] = UIColor(rgb: colors.work)
        self.colors["pause"] = UIColor(rgb: colors.pause)
        
        buildTimerProgress()
        buildTimerProgressAnimations()
    }
    
    func updateTimer(with timer: CycleTimer) {
        backgroundColor = timer.type == .work ? colors["work"] : colors["pause"]
        timerImageView.image = timer.type == .work ? TimerView.workImage : TimerView.breakImage
        timeLabel.text = TimeFormatter.secToTimeStr(for: timer.duration)
        buttonColor = backgroundColor ?? .black
        
        controlBtn.setTitleColor(backgroundColor, for: .normal)
        controlBtn.setTitleColor(backgroundColor, for: .highlighted)
        updateControlBtn(for: .idle, with: "")
    }
    
    func updateControlBtn(for state: TimerState, with text: String) {
        let baseImage = state == .idle ? TimerView.playIcon : TimerView.forwardIcon
        let image = baseImage.withTintColor(buttonColor, renderingMode: .alwaysOriginal)
        
        self.controlBtn.setImage(image, for: .normal)
        self.controlBtn.setTitle(text, for: .normal)
        self.controlBtn.isEnabled = true
    }
    
    func fillTimerProgressBar(completion: @escaping (() -> Void)) {
        timerProgress.add(initTimerAnimation, forKey: "init-timer")
        DispatchQueue.main.asyncAfter(deadline: .now() + timerAnimationDuration - 0.1) { [weak self] in
            self?.timerProgress.strokeStart = 0
            completion()
        }
    }
    
    func skipTimerProgressBar(at percentage: Float, completion: @escaping (() -> Void)) {
        skipTimerAnimation.fromValue = percentage
        timerProgress.add(skipTimerAnimation, forKey: "init-timer")
        DispatchQueue.main.asyncAfter(deadline: .now() + timerAnimationDuration - 0.1) { [weak self] in
            self?.timerProgress.strokeStart = 1
            completion()
        }
    }
    
    func showUpNext(with timer: CycleTimer) {
        upNextView.layer.opacity = 1
        upNextImage.image = timer.type == .pause ? TimerView.breakImage : TimerView.workImage
        
        upNextImage.image = timer.type == .pause ? TimerView.breakImage : TimerView.workImage
        upNextLabel.text = "\(timer.name): \(TimeFormatter.secToTimeStr(for: timer.duration))"
    }
    
    func hideUpNext() {
        upNextView.layer.opacity = 0
    }
    
    func updateTime(with time: Int, maxTime: Int) {
        timeLabel.text = TimeFormatter.secToTimeStr(for: time)
        timerProgress.strokeStart = 1 - CGFloat(time) / CGFloat(maxTime)
    }
    
    func disableControlBtn() {
        controlBtn.isEnabled = false
    }
    
    private func buildTimerProgress() {
        let radius = CGFloat(120)
        let y = timerImageView.layer.frame.midY
        let x = timerImageView.layer.frame.midX
        
        let center = CGPoint(x: x, y: y)
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
    
    private func buildTimerProgressAnimations() {
        let timeInterval: CFTimeInterval = timerAnimationDuration
        
        initTimerAnimation.fromValue = 1.0
        initTimerAnimation.toValue = 0.0
        initTimerAnimation.isRemovedOnCompletion = false
        initTimerAnimation.duration = timeInterval
        
        skipTimerAnimation.fromValue = 0.0
        skipTimerAnimation.toValue = 1.0
        skipTimerAnimation.isRemovedOnCompletion = false
        skipTimerAnimation.duration = timeInterval
    }
}
