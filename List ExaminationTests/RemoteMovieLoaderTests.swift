//
//  RemoteMovieLoaderTests.swift
//  List ExaminationTests
//
//  Created by Farras on 08/07/24.
//

import XCTest
@testable import List_Examination

class HTTPClientSpy: HTTPClient {
    var urls: [URL] = []
    func get(from url: URL) {
        self.urls.append(url)
    }
}

class RemoteMovieLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromClient() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.urls.isEmpty)
    }
    
    func test_load_requestsDataFromUrl() {
        let (sut, client) = makeSUT()
        
        sut.load()
        
        XCTAssertFalse(client.urls.isEmpty)
    }
    
    func test_loadTwice_requestsDataFromUrlTwice() {
        let (sut, client) = makeSUT()
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.urls.count, 2)
    }
    
    private func makeSUT(url: URL = URL(string: "https://api.themoviedb.org/")!) -> (sut: RemoteMovieLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        return (sut: RemoteMovieLoader(url: url, client: client), client: client)
    }
}
