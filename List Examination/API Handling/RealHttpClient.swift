//
//  RealHttpClient.swift
//  List Examination
//
//  Created by Farras on 08/07/24.
//

import Foundation

class RealHttpClient: HTTPClient {
    
    // TODO: Add currentPage parameter and create new test case for currentPage
    // Instead of assign currentPage to static
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        
        Task {
            var currentPage = MovieViewModel.firstPage
            
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
                completion(.success(data, response as! HTTPURLResponse))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
