//
//  RemoteMovieLoader.swift
//  List Examination
//
//  Created by Farras on 08/07/24.
//

import Foundation

protocol HTTPClient {
    func get(from url: URL) async -> LoadMovieResult
}

final class RemoteMovieLoader {
    private let url: URL
    private let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load() async -> LoadMovieResult {
        return await client.get(from: url)
    }
}
