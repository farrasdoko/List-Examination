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
        "Page 1", "Page 1", "Page 1", "Page 1", "Page 1", "Page 1", "Page 1", "Page 1", "Page 1", "Page 1",
        "Page 2", "Page 2", "Page 2", "Page 2", "Page 2", "Page 2", "Page 2", "Page 2", "Page 2", "Page 2",
        "Page 3", "Page 3", "Page 3", "Page 3", "Page 3", "Page 3", "Page 3", "Page 3", "Page 3", "Page 3"
    ]
    var displayedData: [String] = []
    
    static let firstPage: Int = 1
    let pageSize = 10
    let totalPage = 3
    var currentPage = MainVC.firstPage
    
    // MARK: - Views
    let tableView = UITableView()
    let refreshControl = UIRefreshControl()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupRefreshControl()
        setUpSearchController()
        
        loadNextPage()
    }
    
    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    func loadNextPage() {
        DispatchQueue.global().async {
            guard self.currentPage <= self.totalPage else { return }
            let newData = self.fetchData()
            
            DispatchQueue.main.async {
                self.displayedData.append(contentsOf: Array(newData.prefix(self.currentPage * self.pageSize)) )
                self.tableView.reloadData()
                self.currentPage += 1
            }
        }
    }
    
    func fetchData() -> [String] {
        
        let startIndex = (currentPage - 1) * pageSize
        let endIndex = min(startIndex + pageSize, allData.count)
        
        var newData: [String] = []
        for i in startIndex..<endIndex {
            newData.append(allData[i])
        }
        
        return newData
    }
    
    // MARK: - Pull to Refresh
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    @objc func refreshData() {
        currentPage = MainVC.firstPage
        displayedData.removeAll()
        
        loadNextPage()
        
        refreshControl.endRefreshing()
    }
    
    // MARK: - Searchable
    private func setUpSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
}

extension MainVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = displayedData[indexPath.row]
        
        // Load next page on last cell
        if indexPath.row == displayedData.count - 1 {
            loadNextPage()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailVC = DetailVC()
        navigationController?.pushViewController(detailVC, animated: true)
        
        print("You tapped on \(displayedData[indexPath.row])")
    }
}

extension MainVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
    func filterContentForSearchText(_ searchText: String) {
        if searchText.isEmpty {
            displayedData = allData
        } else {
            displayedData = allData.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
}
