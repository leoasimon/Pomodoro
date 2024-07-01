//
//  ViewController.swift
//  Pomodoro
//
//  Created by Leo on 2024-06-14.
//

import UIKit

class CycleSelectionViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = CycleSelectionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.storyboard = storyboard
        viewModel.navigationController = navigationController
        let cycleCardCellNib = CycleCardCollectionViewCell.nib()
        
        collectionView.register(cycleCardCellNib, forCellWithReuseIdentifier: CycleCardCollectionViewCell.identifier)
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
        
        title = "Select your cycle"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        viewModel.loadCycles()
    }
}

