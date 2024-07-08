//
//  RemoteMovieLoaderTests.swift
//  List ExaminationTests
//
//  Created by Farras on 08/07/24.
//

import XCTest

class RemoteMovieLoader {
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func load() {
        client.get(from: URL(string: "https://api.themoviedb.org/")!)
    }
}

class HTTPClient {
    var url: URL?
    
    func get(from url: URL) {
        self.url = url
    }
}

class RemoteMovieLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromClient() {
        let client = HTTPClient()
        _ = RemoteMovieLoader(client: client)
        
        XCTAssertNil(client.url)
    }
    
    func test_load_requestDataFromUrl() {
        let client = HTTPClient()
        let sut = RemoteMovieLoader(client: client)
        
        sut.load()
        
        XCTAssertNotNil(client.url)
    }
}
