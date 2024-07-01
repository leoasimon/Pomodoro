//
//  TimerViewController.swift
//  Pomodoro
//
//  Created by Leo on 2024-06-23.
//

import UIKit

class TimerViewController: UIViewController {
    
    static var identifier = "TimerView"
    
    @IBOutlet weak var timerLabel: UILabel?
    @IBOutlet weak var controlBtn: UIButton!
    
    var time = 0 {
        didSet {
            timerLabel?.text = secToTimeStr(for: time)
        }
    }
    var timerIndex = 0
    var timer = Timer()
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumIntegerDigits = 2
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 0
        return nf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controlBtn.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
        timerLabel?.text = secToTimeStr(for: time)
    }
    
    func secToTimeStr(for seconds: Int) -> String {
        let h = seconds / (60 * 60)
        let m = (seconds / 60) % 60
        let s = seconds % 60
        
        let hStr = numberFormatter.string(from: NSNumber(value: h))!
        let mStr = numberFormatter.string(from: NSNumber(value: m))!
        let sStr = numberFormatter.string(from: NSNumber(value: s))!

        print(hStr, mStr, sStr)
        return "\(hStr):\(mStr):\(sStr)"
    }
    
    func configure(cycle: Cycle) {
        title = cycle.name
        
        guard let currentTimer = cycle.timers.first else {
            print("This cycle has no timers!")
            return
        }
        
        time = currentTimer.duration * 60
    }
    
    @objc func tick() {
        print("tick!")
        time -= 1
    }
    
    @objc func startTimer() {
        print("About to start the timer! Buckle up guys")
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        
//        print("btn title: \(controlBtn.titleLabel)")
        controlBtn.titleLabel?.text = "Stop"
        controlBtn.backgroundColor = .red
    }
    
    @objc func stopTimer() {
        timer.invalidate()
        
        controlBtn.titleLabel?.text = "Start"
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
