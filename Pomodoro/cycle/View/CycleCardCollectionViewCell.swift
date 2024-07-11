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
    @IBOutlet var workTimeLabel: UILabel!
    @IBOutlet var pauseTimeLabel: UILabel!
    
    var viewModel: CycleCardCellViewModel? {
        didSet {
            fillUI()
        }
    }
    
    static let identifier = "CycleCardCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func fillUI() {
        guard let viewModel = viewModel else {
            return
        }
        
        view.backgroundColor = UIColor(rgb: viewModel.cycle.colors.work)
        nameLabel.text = viewModel.cycle.name
        selectBtn.titleLabel?.textColor = UIColor(rgb: viewModel.cycle.colors.work)
        workTimeLabel.text = TimeFormatter.secToTimeStr(for: viewModel.cycle.timers[0].duration)
        pauseTimeLabel.text = TimeFormatter.secToTimeStr(for: viewModel.cycle.timers[1].duration)
        layer.cornerRadius = 14
        
    }
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    @IBAction func openTimer() {
        viewModel?.openTimerView()
    }
    
    @IBAction func openInfo() {
        viewModel?.openInfo()
    }
}
