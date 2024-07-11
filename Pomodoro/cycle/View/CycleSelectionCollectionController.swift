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
        
        viewModel.storyboard = storyboard
        viewModel.navigationController = navigationController
        let cycleCardCellNib = CycleCardCollectionCellView.nib()
        
        collectionView.register(cycleCardCellNib, forCellWithReuseIdentifier: CycleCardCollectionCellView.identifier)
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
        
        title = "Select your cycle"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        viewModel.loadCycles()
    }
}

