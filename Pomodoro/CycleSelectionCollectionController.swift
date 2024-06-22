//
//  ViewController.swift
//  Pomodoro
//
//  Created by Leo on 2024-06-14.
//

import UIKit

class CycleSelectionCollectionController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let cycles: [Cycle] = [
        Cycle(name: "Classic Pomodoro", colors: CycleColors(work: 0xFF6347, pause: 0xFF9F43)),
        Cycle(name: "DeskTime 2014", colors: CycleColors(work: 0x1DD1A1, pause: 0xFF6E4E)),
        Cycle(name: "In The Zone", colors: CycleColors(work: 0x5F27CD, pause: 0xCD7727))
    ]
    
    override func viewDidLoad() {
        print("Loading view")
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let cycleCardCellNib = CycleCardCollectionViewCell.nib()
        
        print("Cycle card cell nib: \(cycleCardCellNib)")
        
        collectionView.register(cycleCardCellNib, forCellWithReuseIdentifier: CycleCardCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //        let layout = UICollectionViewFlowLayout()
        //        layout.itemSize = CGSize(width: 120, height: 120)
        //        collectionView.collectionViewLayout =  layout
        
        title = "Select your cycle"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension CycleSelectionCollectionController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        //        print("You tapped me")
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "TimerView") else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CycleSelectionCollectionController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cycles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CycleCardCollectionViewCell.identifier, for: indexPath) as! CycleCardCollectionViewCell
        
        cell.configure(with: cycles[indexPath.row], selectionActionDelegate: self)
        
        return cell
    }
}

extension CycleSelectionCollectionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = 12.0
        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
        
        return CGSize(width: availableWidth - (padding * 2.0), height: 213)
    }
}

protocol CycleSelectionAction {
    func openCycleInfos(cycle: Cycle)
    
    func openCycleTimer(cycle: Cycle)
}

extension CycleSelectionCollectionController: CycleSelectionAction {
    func openCycleInfos(cycle: Cycle) {
        print("Should open cycle info for \(cycle.name)")
    }
    
    func openCycleTimer(cycle: Cycle) {
        print("Should open timer for \(cycle.name)")
    }
}

//extension CycleSelectionCollectionController" "
