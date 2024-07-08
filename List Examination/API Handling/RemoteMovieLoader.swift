//
//  RemoteMovieLoader.swift
//  List Examination
//
//  Created by Farras on 08/07/24.
//

import Foundation

final class RemoteMovieLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
        case unknownError
    }
    
    public typealias Result = LoadMovieResult
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(completion: @escaping(Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(data, response):
                completion(map(data, from: response))
            case .failure:
                completion(.failed(Error.connectivity))
            }
        }
    }
    
    private var OK_200: Int { return 200 }
    
    internal func map(_ data: Data, from response: HTTPURLResponse) -> RemoteMovieLoader.Result {
        guard response.statusCode == OK_200,
              let apiResult = try? JSONDecoder().decode(APIResult.self, from: data) else {
            return .failed(RemoteMovieLoader.Error.invalidData)
        }
        return .success(apiResult)
    }
}
