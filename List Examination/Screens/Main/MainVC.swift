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
    
    // MARK: - UI Elements
    let tableView = UITableView()
    let refreshControl = UIRefreshControl()
    let searchView = UIView()
    let searchTf = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupTableView()
        setupRefreshControl()
        setUpSearchController()
        
        loadNextPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        tableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Pagination
    
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
        // TODO: Make it a class instead of manual in case of reuse.
        searchView.backgroundColor = #colorLiteral(red: 0.9467977881, green: 0.9467977881, blue: 0.9467977881, alpha: 1)
        searchView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchView)
        NSLayoutConstraint.activate([
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchView.topAnchor.constraint(equalTo: view.topAnchor),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -20),
        ])
        
        searchView.addSubview(searchTf)
        searchTf.translatesAutoresizingMaskIntoConstraints = false
        searchTf.delegate = self
        searchTf.placeholder = "Search"
        searchTf.font = UIFont(name: "Poppins-Regular", size: 12.0)
        NSLayoutConstraint.activate([
            searchTf.leadingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: 16),
            searchTf.topAnchor.constraint(equalTo: searchView.safeAreaLayoutGuide.topAnchor, constant: 18),
        ])
        
        let searchImg = UIImage(systemName: "magnifyingglass")
        let searchImgView = UIImageView(image: searchImg)
        searchImgView.tintColor = .black
        searchImgView.translatesAutoresizingMaskIntoConstraints = false
        searchView.addSubview(searchImgView)
        NSLayoutConstraint.activate([
            searchImgView.leadingAnchor.constraint(equalTo: searchTf.trailingAnchor, constant: 8),
            searchImgView.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: -20),
            searchImgView.centerYAnchor.constraint(equalTo: searchTf.centerYAnchor),
        ])
        
        let bottomBorder = UIView()
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        searchView.addSubview(bottomBorder)
        bottomBorder.backgroundColor = #colorLiteral(red: 0.5406724811, green: 0.5406724811, blue: 0.5406724811, alpha: 1)
        NSLayoutConstraint.activate([
            bottomBorder.leadingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: 16),
            bottomBorder.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: -15),
            bottomBorder.topAnchor.constraint(equalTo: searchTf.bottomAnchor, constant: 9),
            bottomBorder.bottomAnchor.constraint(equalTo: searchView.bottomAnchor, constant: -11),
            bottomBorder.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    @objc private func searchButtonTapped() {
        searchTf.endEditing(true)
        filterContentForSearchText(searchTf.text ?? "")
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

extension MainVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier) as! MovieCell
        
        let movieTitle = displayedData[indexPath.row]
        let movieYear = "2022"
        let movieGenre = "Drama, Asia, Comedy, Series"
        
        cell.configure(with: movieTitle, year: movieYear, genre: movieGenre)
        
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

extension MainVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        filterContentForSearchText(updatedText)
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchButtonTapped()
        return true
    }
}
