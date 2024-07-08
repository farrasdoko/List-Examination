//
//  HTTPClient.swift
//  List Examination
//
//  Created by Farras on 08/07/24.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL) async -> HTTPClientResult
}
