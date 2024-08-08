//
//  TimerViewAnimation.swift
//  Pomodoro
//
//  Created by Leo on 2024-08-06.
//

import Foundation
import UIKit

protocol TimerViewAnimationProtocol {
    func animateControlBtn(with newText: String)
    func animateTimerStart(timerType: TimerType, completion: @escaping (() -> Void))
    func animateTimerSkip(timerType: TimerType, at ellapsedTime: Float, completion: @escaping (() -> Void))
}

class TimerViewAnimationDelegate: TimerViewAnimationProtocol {
    let playConstraint: NSLayoutConstraint
    let skipToWorkConstraint: NSLayoutConstraint
    let skipToBreakConstraint: NSLayoutConstraint
    
    let view: TimerView
    
    private let timerAnimationDuration = 0.7
    private let initTimerAnimation: CABasicAnimation
    private let skipTimerAnimation: CABasicAnimation
    
    init(for view: TimerView, colors: CycleColors) {
        self.view = view
        
        let skipToWorkTargetWidth = view.skipToWorkModelLabel.frame.width + 32
        let skipToBreakTargetWidth = view.skipToBreakModelLabel.frame.width + 32
        let playTargetWidth = view.controlBtn.frame.width
        
        playConstraint = view.controlBtn.widthAnchor.constraint(equalToConstant: playTargetWidth)
        skipToWorkConstraint = view.controlBtn.widthAnchor.constraint(equalToConstant: skipToWorkTargetWidth)
        skipToBreakConstraint = view.controlBtn.widthAnchor.constraint(equalToConstant: skipToBreakTargetWidth)
        
        let timeInterval: CFTimeInterval = timerAnimationDuration
        
        initTimerAnimation = CABasicAnimation(keyPath: "strokeStart")
        initTimerAnimation.fromValue = 1.0
        initTimerAnimation.toValue = 0.0
        initTimerAnimation.isRemovedOnCompletion = false
        initTimerAnimation.duration = timeInterval
        
        skipTimerAnimation = CABasicAnimation(keyPath: "strokeStart")
        skipTimerAnimation.fromValue = 0.0
        skipTimerAnimation.toValue = 1.0
        skipTimerAnimation.isRemovedOnCompletion = false
        skipTimerAnimation.duration = timeInterval
        
//        NSLayoutConstraint.activate([
//            playConstraint,
//            view.controlBtn.heightAnchor.constraint(equalToConstant: view.controlBtn.frame.height)
//        ])
    }
    
    func animateControlBtn(with newText: String) {
        if newText == "" {
            animateControlBtnCollapse()
        } else {
            animateControlBtnExpand(with: newText)
        }
    }
    
    func animateTimerStart(timerType: TimerType, completion: @escaping (() -> Void)) {
        view.timerProgress.add(initTimerAnimation, forKey: "init-timer")
        DispatchQueue.main.asyncAfter(deadline: .now() + timerAnimationDuration - 0.1) {
            completion()
        }
    }
    
    func animateTimerSkip(timerType: TimerType, at ellapsedTime: Float, completion: @escaping (() -> Void)) {
        skipTimerAnimation.fromValue = 1 - ellapsedTime
        view.timerProgress.add(skipTimerAnimation, forKey: "skip-timer")
        DispatchQueue.main.asyncAfter(deadline: .now() + timerAnimationDuration - 0.1) {
            completion()
        }
    }
    
    
    private func animateControlBtnExpand(with text: String) {
        playConstraint.isActive = false
        
        let constraint = text == "Skip to work" ? self.skipToWorkConstraint : self.skipToBreakConstraint
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: { [weak self] in
            self?.view.controlBtn.titleLabel?.layer.opacity = 1
            constraint.isActive = true
            self?.view.layoutIfNeeded()
        })
    }
    
    private func animateControlBtnCollapse() {
        skipToWorkConstraint.isActive = false
        skipToBreakConstraint.isActive = false
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: { [weak self] in
            self?.view.controlBtn.titleLabel?.layer.opacity = 0
            self?.playConstraint.isActive = true
            self?.view.layoutIfNeeded()
        })
    }
}
