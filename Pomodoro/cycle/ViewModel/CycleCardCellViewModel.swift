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
