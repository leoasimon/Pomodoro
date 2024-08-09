//
//  ViewController.swift
//  Pomodoro
//
//  Created by Leo on 2024-06-14.
//

import UIKit

class CycleSelectionView: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = CycleSelectionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.navigationDelegate = self
        viewModel.navigationController = navigationController
        let cycleCardCellNib = CycleCardCollectionCellView.nib()
        
        collectionView.register(cycleCardCellNib, forCellWithReuseIdentifier: CycleCardCollectionCellView.identifier)
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
        
        viewModel.loadCycles()
    }
}

extension CycleSelectionView: CycleSelectionNavigationDelegate {
    func openCycle(with cycle: Cycle) {
        guard let timerView = storyboard?.instantiateViewController(withIdentifier: TimerViewController.identifier) as? TimerViewController else {
            print("Unable to instantiate timer view")
            return
        }
        
        timerView.configure(with: cycle)
        navigationController?.pushViewController(timerView, animated: true)
    }
    
    @objc func closeTimer() {
        print("Should close the timer now")
    }
}

