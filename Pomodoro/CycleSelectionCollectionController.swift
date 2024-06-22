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
        Cycle(name: "Classic Pomodoro"),
        Cycle(name: "DeskTime 2014"),
        Cycle(name: "In The Zone"),
        Cycle(name: "My own flavour")
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
        
        print("You tapped me")
    }
}

extension CycleSelectionCollectionController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cycles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CycleCardCollectionViewCell.identifier, for: indexPath) as! CycleCardCollectionViewCell
        
        cell.configure(with: cycles[indexPath.row])
        
        return cell
    }
}

extension CycleSelectionCollectionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = 12.0
        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
        
        return CGSize(width: availableWidth - (padding * 2.0), height: 213)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Hello")
    }
}

//extension CycleSelectionCollectionController" "
