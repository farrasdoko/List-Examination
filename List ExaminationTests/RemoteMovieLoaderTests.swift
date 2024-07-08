//
//  RemoteMovieLoaderTests.swift
//  List ExaminationTests
//
//  Created by Farras on 08/07/24.
//

import XCTest
import Combine
@testable import List_Examination

private class HTTPClientSpy: HTTPClient {
    private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
    
    var urls: [URL] {
        return messages.map { $0.url }
    }
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        messages.append((url, completion))
    }
    
    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }
    
    func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
        let response = HTTPURLResponse(
            url: urls[index],
            statusCode: code,
            httpVersion: nil,
            headerFields: nil)!
        messages[index].completion(.success(data, response))
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
        
        sut.load { _ in }
        
        XCTAssertFalse(client.urls.isEmpty)
    }
    
    func test_loadTwice_requestsDataFromUrlTwice() {
        let (sut, client) = makeSUT()
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.urls.count, 2)
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failed(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failed(.invalidData), when: {
                let json = makeAPIResultJSON()
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }
    
    func test_load_success200() {
        let (sut, client) = makeSUT()
        let samples = [200]
        
        let apiResult = makeAPIResultDummy()
        
        samples.enumerated().forEach { _, code in
            expect(sut, toCompleteWith: .success(apiResult), when: {
                let json = makeAPIResultJSON()
                client.complete(withStatusCode: code, data: json)
            })
        }
    }
    
    func test_load_checkErrorOnClientSucceed() {
        let expectation = XCTestExpectation(description: "Fetch data expectation")
        let (sut, client) = makeSUT()
        
        let json = makeAPIResultJSON()
        
        sut.load { movieResult in
            var capturedError = [Error]()
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
        
        client.complete(withStatusCode: 200, data: json)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    private func makeSUT(url: URL = URL(string: "https://api.themoviedb.org/")!) -> (sut: RemoteMovieLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        return (sut: RemoteMovieLoader(url: url, client: client), client: client)
    }
    
    private func expect(_ sut: RemoteMovieLoader, toCompleteWith expectedResult: RemoteMovieLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line){
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
                
            case let (.failed(receivedError as RemoteMovieLoader.Error), .failed(expectedError as RemoteMovieLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 10.0)
    }
    
    private func makeAPIResultJSON(result: APIResult = APIResult(page: 0, results: [], totalPages: 0, totalResults: 0)) -> Data {
        let data = try! JSONEncoder().encode(result)
        return data
    }
    
    private func makeAPIResultDummy() -> APIResult {
        return APIResult(page: 0, results: [], totalPages: 0, totalResults: 0)
    }
}
