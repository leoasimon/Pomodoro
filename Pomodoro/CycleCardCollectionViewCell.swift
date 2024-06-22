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
    
    static let identifier = "CycleCardCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with cycleConf: Cycle) {
        nameLabel.text = cycleConf.name

        layer.cornerRadius = 14
//        selectBtn.color
//        selectBtn.inset
    }
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
