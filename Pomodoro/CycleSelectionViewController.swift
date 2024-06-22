//
//  CelectionViewController.swift
//  Pomodoro
//
//  Created by Leo on 2024-06-22.
//

import UIKit

class CycleSelectionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Select your cycle"
        navigationController?.navigationBar.prefersLargeTitles = true
        
//        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension CycleSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionCardCell", for: indexPath)
        
        return cell
    }
}
