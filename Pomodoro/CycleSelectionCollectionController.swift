//
//  ViewController.swift
//  Pomodoro
//
//  Created by Leo on 2024-06-14.
//

import UIKit

class CycleSelectionViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    static let pomodoroWorkTimer = CycleTimer(type: .work, duration: 25)
    static let pomodoroPauseTimer = CycleTimer(type: .pause, duration: 5)
    static let pomodoroLongPauseTimer = CycleTimer(type: .pause, duration: 15)
    
    static let pomodoroTimers = [pomodoroWorkTimer, pomodoroPauseTimer, pomodoroWorkTimer, pomodoroPauseTimer, pomodoroWorkTimer, pomodoroPauseTimer, pomodoroWorkTimer, pomodoroLongPauseTimer]
    
    var cycles: [Cycle] = []
    
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
        
        loadCycles()
    }
    
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
        
        print(jsonCycles)
        cycles = jsonCycles
    }
}

extension CycleSelectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        //        print("You tapped me")
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "TimerView") else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CycleSelectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cycles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CycleCardCollectionViewCell.identifier, for: indexPath) as! CycleCardCollectionViewCell
        
        cell.configure(with: cycles[indexPath.row], selectionActionDelegate: self)
        
        return cell
    }
}

extension CycleSelectionViewController: UICollectionViewDelegateFlowLayout {
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

extension CycleSelectionViewController: CycleSelectionAction {
    func openCycleInfos(cycle: Cycle) {
        print("Should open cycle info for \(cycle.name)")
    }
    
    func openCycleTimer(cycle: Cycle) {
        print("Should open timer for \(cycle.name)")
        
        guard let timerView = storyboard?.instantiateViewController(withIdentifier: TimerViewController.identifier) as? TimerViewController else {
            print("Unable to instantiate timer view")
            return
        }
        
        timerView.configure(cycle: cycle)
        navigationController?.pushViewController(timerView, animated: true)
    }
}
