//
//  TimerV2View.swift
//  Pomodoro
//
//  Created by Leo on 2024-08-09.
//

import UIKit

class TimerV2View: UIView, TimerUIDelegateV2 {
    @IBOutlet weak var timerImageView: UIImageView!
    
    @IBOutlet weak var upNextLabel: UILabel!
    @IBOutlet weak var upNextImage: UIImageView!
    @IBOutlet weak var upNextView: UIView!
    
    var colors = ["work": UIColor.blue, "pause": UIColor.orange]
    
    private let timerProgressPlaceholder = CAShapeLayer()
    let timerProgress = CAShapeLayer()
    
    private let timerAnimationDuration = 0.7
    let initTimerAnimation = CABasicAnimation(keyPath: "strokeStart")
    let skipTimerAnimation = CABasicAnimation(keyPath: "strokeStart")
    
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
        self.backgroundColor = timer.type == .work ? colors["work"] : colors["pause"]
        timerImageView.image = timer.type == .work ? TimerView.workImage : TimerView.breakImage
    }
    
    
    private func buildTimerProgress() {
        let radius = CGFloat(120)
        let center = CGPoint(x: timerImageView.frame.midX, y: timerImageView.frame.midY)
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
    
    func fillTimerProgressBar(completion: @escaping (() -> Void)) {
        timerProgress.add(initTimerAnimation, forKey: "init-timer")
        DispatchQueue.main.asyncAfter(deadline: .now() + timerAnimationDuration - 0.1) { [weak self] in
            self?.timerProgress.strokeStart = 0
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
}
