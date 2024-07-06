//
//  MainVC.swift
//  List Examination
//
//  Created by Farras on 06/07/24.
//

import UIKit

class MainVC: UIViewController {
    
    // MARK: - Data variables
    let allData = [
        "Data", "Diti", "Dutu", "Dete", "Doto"
    ]
    var displayedData: [String] = []
    
    // MARK: - Views
    let tableView = UITableView()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupRefreshControl()
        
        loadData()
    }
    
    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    func loadData() {
        DispatchQueue.global().async {
            self.displayedData = self.allData
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Pull to Refresh
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    @objc func refreshData() {
        displayedData.removeAll()
        
        loadData()
        
        refreshControl.endRefreshing()
    }
    
}

extension MainVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = displayedData[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("You tapped on \(displayedData[indexPath.row])")
    }
}
