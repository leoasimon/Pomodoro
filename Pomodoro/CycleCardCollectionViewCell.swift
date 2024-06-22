//
//  CycleCardCollectionViewCell.swift
//  Pomodoro
//
//  Created by Leo on 2024-06-20.
//
import UIKit

class CycleCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var view: UIView!
    @IBOutlet var selectBtn: UIButton!
    @IBOutlet var infoBtn: UIButton!
    
    var cycleSelectionActionDelegate: CycleSelectionAction!
    var cycle: Cycle!
    
    static let identifier = "CycleCardCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectBtn.addTarget(self, action: #selector(openTimerView), for: .touchUpInside)
        infoBtn.addTarget(self, action: #selector(openInfo), for: .touchUpInside)
    }
    
    public func configure(with cycleConf: Cycle, selectionActionDelegate: CycleSelectionAction) {
        
        cycleSelectionActionDelegate = selectionActionDelegate
        cycle = cycleConf
        
        view.backgroundColor = UIColor(rgb: cycleConf.colors.work)
        nameLabel.text = cycleConf.name
        selectBtn.titleLabel?.textColor = UIColor(rgb: cycleConf.colors.work)
        layer.cornerRadius = 14
    }
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    @objc func openTimerView() {
        cycleSelectionActionDelegate.openCycleTimer(cycle: cycle)
    }
    
    @objc func openInfo() {
        cycleSelectionActionDelegate.openCycleInfos(cycle: cycle)
    }
}
