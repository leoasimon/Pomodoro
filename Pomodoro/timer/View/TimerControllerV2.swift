//
//  TimerControllerV2.swift
//  Pomodoro
//
//  Created by Leo on 2024-08-09.
//

import UIKit

class TimerControllerV2: UIViewController {

    var cycles = [Cycle]()
    let timerViewModel = TimerViewModelV2()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCycles()
        
        guard let view = view as? TimerViewV2 else { return }
        guard let cycle = cycles.first else  { return }
        
        view.configure(colors: cycle.colors)
        timerViewModel.configure(uiDelegate: view, cycle: cycle)
        
        guard let firstTimer = cycle.timers.first else { return }
        view.updateTimer(with: firstTimer)
    }
    
    func loadCycles() {
        guard let cyclesFileUrl = Bundle.main.url(forResource: "cycles", withExtension: "json") else {
            print("Unable to locate the cycles file")
            return
        }
        
        guard let cyclesContent = try? Data(contentsOf: cyclesFileUrl) else {
            print("Unable to read the content for the cycles file")
            return
        }
        
        let decoder = JSONDecoder()
        guard let jsonCycles = try? decoder.decode([Cycle].self, from: cyclesContent) else {
            print("Unable to parse the cycle configuration file")
            // TODO: Show a dialog to the user
            return
        }
        
        cycles = jsonCycles
    }
    
    @IBAction func handleTimerBtn(_ sender: Any) {
        self.timerViewModel.handleControlTouched()
    }
}
