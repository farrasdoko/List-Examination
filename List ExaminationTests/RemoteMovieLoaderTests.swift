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
    var success: (data: Data, response: HTTPURLResponse)!
    
    func get(from url: URL) async -> HTTPClientResult {
        let result: HTTPClientResult
        if let error {
            result = .failure(error)
        } else {
            if success == nil {
                result = .failure(RemoteMovieLoader.Error.unknownError)
            } else {
                result = .success(success.data, success.response)
            }
        }
        urls.append(url)
        return result
    }
    
    func complete(with error: Error, at index: Int = 0) {
        self.error = error
    }
    
    func complete(on url: URL, withStatusCode code: Int, data: Data) {
        let response = HTTPURLResponse(
            url: url,
            statusCode: code,
            httpVersion: nil,
            headerFields: nil)!
        self.success = (data, response)
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
        let clientError = NSError (domain: "Test", code: 0)
        client.complete(with: clientError)
        
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
        let (sut, client) = makeSUT()
        
        let apiResult = APIResult(page: 0, results: [], totalPages: 0, totalResults: 0)
        let data = try! JSONEncoder().encode(apiResult)
        client.complete(on: URL(string: "https://a.com")!, withStatusCode: 200, data: data)
        
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
