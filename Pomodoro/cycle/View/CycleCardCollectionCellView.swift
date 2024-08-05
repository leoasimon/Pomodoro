//
//  CycleCardCollectionViewCell.swift
//  Pomodoro
//
//  Created by Leo on 2024-06-20.
//
import UIKit

class CycleCardCollectionCellView: UICollectionViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var view: UIView!
    @IBOutlet var selectBtn: UIButton!
    @IBOutlet var workTimeLabel: UILabel!
    @IBOutlet var pauseTimeLabel: UILabel!

    static let identifier = "CycleCardCollectionViewCell"

    private var viewModel = CycleCardCellViewModel()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with cycle: Cycle, selectionActionDelegate: CycleCellActionsDelegate) {
        viewModel.configure(with: cycle, selectionActionDelegate: selectionActionDelegate)

        self.fillUI()
    }

    func fillUI() {
        assert(viewModel.cycle != nil, "No cycle define in the viewModel, did you forget to call it's configure() method?")
        guard let cycle = viewModel.cycle else { return }

        view.backgroundColor = UIColor(rgb: cycle.colors.work)
        nameLabel.text = cycle.name
        selectBtn.titleLabel?.textColor = UIColor(rgb: cycle.colors.work)
        workTimeLabel.text = TimeFormatter.secToTimeStr(for: cycle.timers[0].duration)
        pauseTimeLabel.text = TimeFormatter.secToTimeStr(for: cycle.timers[1].duration)
        layer.cornerRadius = 14
    }
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    @IBAction func openTimer() {
        viewModel.openTimerView()
    }
    
    @IBAction func openInfo() {
        viewModel.openInfo()
    }
}
