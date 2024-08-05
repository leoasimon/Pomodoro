//
//  CycleCardCellViewModel.swift
//  Pomodoro
//
//  Created by Leo on 2024-07-01.
//

import UIKit

class CycleCardCellViewModel: NSObject {
    var cycleSelectionActionDelegate: CycleCellActionsDelegate?
    var cycle: Cycle?
    
    func openTimerView() {
        assert(cycle != nil && cycleSelectionActionDelegate != nil, "It seems some important objects were not initialized, did you forget to call the configure() method?")
        guard let cycle = self.cycle else { return }
        cycleSelectionActionDelegate?.openCycleTimer(cycle: cycle)
    }
    
    func openInfo() {
        assert(cycle != nil && cycleSelectionActionDelegate != nil, "It seems some important objects were not initialized, did you forget to call the configure() method?")
        guard let cycle = self.cycle else { return }
        cycleSelectionActionDelegate?.openCycleInfos(cycle: cycle)
    }
    
    public func configure(with cycleConf: Cycle, selectionActionDelegate: CycleCellActionsDelegate) {
        cycleSelectionActionDelegate = selectionActionDelegate
        cycle = cycleConf
    }
}
