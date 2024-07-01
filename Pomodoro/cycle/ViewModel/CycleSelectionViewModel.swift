//
//  CycleSelectionViewModel.swift
//  Pomodoro
//
//  Created by Leo on 2024-07-01.
//

import UIKit

final class CycleSelectionViewModel: NSObject {
    var cycles: [Cycle] = []
    var storyboard: UIStoryboard?
    var navigationController: UINavigationController?
    
    func loadCycles() {
        guard let cyclesFileUrl = Bundle.main.url(forResource: "cycles", withExtension: "json") else {
            print("Unable to locate the cycles file")
            return
        }
        
        guard let cyclesContent = try? Data(contentsOf: cyclesFileUrl) else {
            print("Unable to read the content for the cycles file")
            return
        }
        
        let decoder = JSONDecoder()
        let jsonCycles = try! decoder.decode([Cycle].self, from: cyclesContent)
        
        cycles = jsonCycles
    }
}

protocol CycleCellActionsDelegate {
    func openCycleInfos(cycle: Cycle)
    
    func openCycleTimer(cycle: Cycle)
}

extension CycleSelectionViewModel: CycleCellActionsDelegate {
    
    func openCycleInfos(cycle: Cycle) {
        print("Should open cycle info for \(cycle.name)")
    }
    
    func openCycleTimer(cycle: Cycle) {
        guard let timerView = storyboard?.instantiateViewController(withIdentifier: TimerViewController.identifier) as? TimerViewController else {
            print("Unable to instantiate timer view")
            return
        }
        
        timerView.configure(with: cycle)
        navigationController?.pushViewController(timerView, animated: true)
    }
}

extension CycleSelectionViewModel: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "TimerView") else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CycleSelectionViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cycles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CycleCardCollectionViewCell.identifier, for: indexPath) as! CycleCardCollectionViewCell
        
        let cellViewModel = CycleCardCellViewModel()
        cellViewModel.configure(with: cycles[indexPath.row], selectionActionDelegate: self)
        
        cell.viewModel = cellViewModel
        
        return cell
    }
}

extension CycleSelectionViewModel: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = 12.0
        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
        
        return CGSize(width: availableWidth - (padding * 2.0), height: 213)
    }
}
