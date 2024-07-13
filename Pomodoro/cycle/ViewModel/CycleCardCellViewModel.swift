//
//  CycleCardCellViewModel.swift
//  Pomodoro
//
//  Created by Leo on 2024-07-01.
//

import UIKit

class CycleCardCellViewModel: NSObject {
    var cycleSelectionActionDelegate: CycleCellActionsDelegate!
    var cycle: Cycle!
    // it's usually a good idea to have delegates as optional, specially in this case where the assignment of the delegate happens only when a configure function is called. Maybe we could have a better option in how to handle these scenarios?
    
    func openTimerView() {
        cycleSelectionActionDelegate.openCycleTimer(cycle: cycle)
    }
    
    func openInfo() {
        cycleSelectionActionDelegate.openCycleInfos(cycle: cycle)
    }
    
    public func configure(with cycleConf: Cycle, selectionActionDelegate: CycleCellActionsDelegate) {
        
        cycleSelectionActionDelegate = selectionActionDelegate
        cycle = cycleConf
    }
}
