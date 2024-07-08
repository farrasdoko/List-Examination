//
//  RemoteMovieLoaderTests.swift
//  List ExaminationTests
//
//  Created by Farras on 08/07/24.
//

import XCTest

class RemoteMovieLoader {
    let url: URL
    let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load() {
        client.get(from: url)
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

class HTTPClientSpy: HTTPClient {
    var url: URL?
    func get(from url: URL) {
        self.url = url
    }
}

class RemoteMovieLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromClient() {
        let (_, client) = makeSUT()
        
        XCTAssertNil(client.url)
    }
    
    func test_load_requestDataFromUrl() {
        let (sut, client) = makeSUT()
        
        sut.load()
        
        XCTAssertNotNil(client.url)
    }
    
    private func makeSUT(url: URL = URL(string: "https://api.themoviedb.org/")!) -> (sut: RemoteMovieLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        return (sut: RemoteMovieLoader(url: url, client: client), client: client)
    }
}
