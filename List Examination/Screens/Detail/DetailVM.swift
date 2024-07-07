//
//  DetailVM.swift
//  List Examination
//
//  Created by Farras on 08/07/24.
//

import Foundation
import Combine

class MovieDetailViewModel {
    @Published var casts = [Cast]()
    @Published var movieId: Int?
    @Published var data: MovieDetail?
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchDataAndCast() {
        Publishers.Zip(fetchData(), fetchCast())
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Both tasks finished successfully.")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { [weak self] (data, cast) in
                self?.processDatas(data: data, cast: cast)
            })
            .store(in: &cancellables)
    }
    
    func fetchCast() -> AnyPublisher<Data, URLError> {
        guard let movieId = self.movieId else {
                    return Fail(error: URLError(.badURL))
                        .eraseToAnyPublisher()
                }
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(String(movieId))/credits")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlM2Q1YWIzNjdlYTY3ZGY1OTg1ZjYyYTJkMjExOGQyZCIsIm5iZiI6MTcyMDM0NTc4Mi41NzA5NDEsInN1YiI6IjVhZDAwMzI4OTI1MTQxN2I2MDAwNDYxMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.jeuj_kdlpGm4qVPaCYstpiY3yFpBkshjNiHCU5VuqhY"
        ]
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .eraseToAnyPublisher()
    }
    
    func fetchData() -> AnyPublisher<Data, URLError> {
        guard let movieId = self.movieId else {
                    return Fail(error: URLError(.badURL))
                        .eraseToAnyPublisher()
                }
        let url = URL(string: "https://api.themoviedb.org/3/movie/"+String(movieId))!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlM2Q1YWIzNjdlYTY3ZGY1OTg1ZjYyYTJkMjExOGQyZCIsIm5iZiI6MTcyMDM0NTc4Mi41NzA5NDEsInN1YiI6IjVhZDAwMzI4OTI1MTQxN2I2MDAwNDYxMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.jeuj_kdlpGm4qVPaCYstpiY3yFpBkshjNiHCU5VuqhY"
        ]
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .eraseToAnyPublisher()
    }
    
    func processDatas(data: Data, cast: Data) {
        processData(data: data)
        processCast(cast: cast)
    }
    
    func processData(data: Data) {
        do {
            let decoder = JSONDecoder()
            let movieDetail = try decoder.decode(MovieDetail.self, from: data)
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.data = movieDetail
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    func processCast(cast: Data) {
        do {
            let decoder = JSONDecoder()
            let castResult = try decoder.decode(CastResult.self, from: cast)
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.casts = castResult.cast ?? []
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
}
