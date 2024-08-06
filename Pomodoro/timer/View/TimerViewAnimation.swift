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
}

class TimerViewAnimationDelegate: TimerViewAnimationProtocol {
    
    let playConstraint: NSLayoutConstraint
    let skipToWorkConstraint: NSLayoutConstraint
    let skipToBreakConstraint: NSLayoutConstraint
    
    let view: TimerView
    
    init(for view: TimerView) {
        self.view = view
        
        let skipToWorkTargetWidth = view.skipToWorkModelLabel.frame.width + 32
        let skipToBreakTargetWidth = view.skipToBreakModelLabel.frame.width + 32
        let playTargetWidth = view.controlBtn.frame.width
        
        playConstraint = view.controlBtn.widthAnchor.constraint(equalToConstant: playTargetWidth)
        skipToWorkConstraint = view.controlBtn.widthAnchor.constraint(equalToConstant: skipToWorkTargetWidth)
        skipToBreakConstraint = view.controlBtn.widthAnchor.constraint(equalToConstant: skipToBreakTargetWidth)
        
        NSLayoutConstraint.activate([
            playConstraint,
            view.controlBtn.heightAnchor.constraint(equalToConstant: view.controlBtn.frame.height)
        ])
    }
    func animateControlBtn(with newText: String) {
        if newText == "" {
            animateControlBtnCollapse()
        } else {
            animateControlBtnExpand(with: newText)
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
