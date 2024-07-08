//
//  MainVM.swift
//  List Examination
//
//  Created by Farras on 08/07/24.
//

import Foundation
import Combine

class MovieViewModel {
    var allData: [Movie] = []
    @Published var displayedData: [Movie] = []
    
    var isSearching = false
    
    static let firstPage: Int = 1
    var totalPage = 3
    var currentPage = MovieViewModel.firstPage
    
    private var cancellables = Set<AnyCancellable>()
    
    func refreshData() {
        currentPage = MovieViewModel.firstPage
        allData.removeAll()
        displayedData.removeAll()
        
        loadNextPage()
    }
    
    func filterContentForSearchText(_ searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            displayedData = allData
        } else {
            isSearching = true
            displayedData = allData.filter { ($0.title ?? "").lowercased().contains(searchText.lowercased()) || ($0.originalTitle ?? "").lowercased().contains(searchText.lowercased()) }
        }
    }
    
    func loadNextPage() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            guard self.currentPage <= self.totalPage else { return }
            Task {
                await self.fetchData()
            }
        }
    }
    
    private func fetchData() async {
        // TODO: Implement RealHTTPClient
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
        
        /*
         
        // Alternatively fetch data asynchronously from a network API using combine instead of async await.
         
        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: APIResult.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            } receiveValue: { [weak self] (apiResult: APIResult) in
                guard let self = self else { return }
                
                self.allData.append(contentsOf: apiResult.results)
                self.displayedData.append(contentsOf: apiResult.results)
                
                self.currentPage = apiResult.page + 1
                self.totalPage = apiResult.totalPages
            }
            .store(in: &cancellables)
         */
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            let decoder = JSONDecoder()
            let apiResult = try decoder.decode(APIResult.self, from: data)
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.allData.append(contentsOf: apiResult.results)
                self.displayedData.append(contentsOf: apiResult.results)
                
                currentPage = apiResult.page + 1
                totalPage = apiResult.totalPages
            }
            
            for movie in apiResult.results {
                print("Movie Title: \(movie.title ?? "")")
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
}
