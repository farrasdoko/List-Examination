//
//  MainVC.swift
//  List Examination
//
//  Created by Farras on 06/07/24.
//

import UIKit

class MainVC: UIViewController {
    
    // MARK: - Data variables
    var allData = [Movie]()
    var displayedData: [Movie] = []
    var isSearching = false
    
    static let firstPage: Int = 1
    var totalPage = 3
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
    
    private func loadNextPage() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            guard self.currentPage <= self.totalPage else { return }
            async {
                await self.fetchData()
            }
        }
    }
    
    private func fetchData() async {
        let url = URL(string: "https://api.themoviedb.org/3/discover/movie")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "include_adult", value: "false"),
          URLQueryItem(name: "include_video", value: "false"),
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "page", value: String(currentPage)),
          URLQueryItem(name: "sort_by", value: "popularity.desc"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlM2Q1YWIzNjdlYTY3ZGY1OTg1ZjYyYTJkMjExOGQyZCIsIm5iZiI6MTcyMDM0NTc4Mi41NzA5NDEsInN1YiI6IjVhZDAwMzI4OTI1MTQxN2I2MDAwNDYxMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.jeuj_kdlpGm4qVPaCYstpiY3yFpBkshjNiHCU5VuqhY"
        ]
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            let decoder = JSONDecoder()
            let apiResult = try decoder.decode(APIResult.self, from: data)
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.allData.append(contentsOf: apiResult.results)
                self.displayedData.append(contentsOf: apiResult.results)
                self.tableView.reloadData()
                
                currentPage = apiResult.page + 1
                totalPage = apiResult.totalPages
            }
            
            for movie in apiResult.results {
                print("Movie Title: \(movie.title)")
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    // MARK: - Pull to Refresh
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    @objc private func refreshData() {
        currentPage = MainVC.firstPage
        allData.removeAll()
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
    
    private func filterContentForSearchText(_ searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            displayedData = allData
        } else {
            isSearching = true
            displayedData = allData.filter { ($0.title ?? "").lowercased().contains(searchText.lowercased()) || ($0.originalTitle ?? "").lowercased().contains(searchText.lowercased()) }
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
        
        let movie = displayedData[indexPath.row]
        let movieTitle = movie.title ?? ""
        let movieYear = "2022"
        let movieGenre = "Drama, Asia, Comedy, Series"
        
        let posterPath = movie.posterPath ?? ""
        let imageUrl = "https://image.tmdb.org/t/p/w300" + posterPath
        
        cell.configure(with: movieTitle, year: movieYear, genre: movieGenre, imageUrl: imageUrl)
        
        // Load next page on last cell
        if !isSearching && indexPath.row == displayedData.count - 1 {
            loadNextPage()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = displayedData[indexPath.row]
        let movieId = movie.id
        
        let detailVC = DetailVC()
        detailVC.movieId = movieId
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
