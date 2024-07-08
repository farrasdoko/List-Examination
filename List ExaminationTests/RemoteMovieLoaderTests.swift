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
    var error: Error?
    
    func get(from url: URL) async -> LoadMovieResult {
        self.urls.append(url)
        if let error {
            return .failed(error)
        } else {
            return .success(APIResult(page: 0, results: [], totalPages: 0, totalResults: 0))
        }
    }
}

class RemoteMovieLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromClient() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.urls.isEmpty)
    }
    
    func test_load_requestsDataFromUrl() {
        let expectation = XCTestExpectation(description: "Fetch data expectation")
        let (sut, client) = makeSUT()
        
        Task {
            _ = await sut.load()
            expectation.fulfill()
            XCTAssertFalse(client.urls.isEmpty)
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_loadTwice_requestsDataFromUrlTwice() {
        let expectation = XCTestExpectation(description: "Fetch data expectation")
        let expectation2 = XCTestExpectation(description: "Fetch data expectation")
        let (sut, client) = makeSUT()
        
        Task {
            let movieResult = await sut.load()
            let movieResult2 = await sut.load()
            
            switch movieResult {
            case .success(_):
                expectation.fulfill()
            case .failed(_):
                expectation.fulfill()
            }
            
            switch movieResult2 {
            case .success(_):
                expectation2.fulfill()
            case .failed(_):
                expectation2.fulfill()
            }
            
            XCTAssertEqual(client.urls.count, 2)
        }
        wait(for: [expectation, expectation2], timeout: 5.0)
    }
    
    func test_load_deliversErrorOnClientError() {
        let expectation = XCTestExpectation(description: "Fetch data expectation")
        let (sut, client) = makeSUT()
        client.error = NSError (domain: "Test", code: 0)
        
        Task {
            var capturedError = [Error]()
            let movieResult = await sut.load()
            
            switch movieResult {
            case .success(_):
                expectation.fulfill()
                XCTAssertEqual(capturedError.count, 1)
            case .failed(let error):
                expectation.fulfill()
                capturedError.append(error)
                XCTAssertEqual(capturedError.count, 1)
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_load_checkErrorOnClientSucceed() {
        let expectation = XCTestExpectation(description: "Fetch data expectation")
        let (sut, _) = makeSUT()
        
        Task {
            var capturedError = [Error]()
            let movieResult = await sut.load()
            
            switch movieResult {
            case .success(_):
                expectation.fulfill()
                XCTAssertEqual(capturedError.count, 0)
            case .failed(let error):
                expectation.fulfill()
                capturedError.append(error)
                XCTAssertEqual(capturedError.count, 0)
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    private func makeSUT(url: URL = URL(string: "https://api.themoviedb.org/")!) -> (sut: RemoteMovieLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        return (sut: RemoteMovieLoader(url: url, client: client), client: client)
    }
}
