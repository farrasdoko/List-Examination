//
//  APIResult.swift
//  List Examination
//
//  Created by Farras on 07/07/24.
//

import Foundation

struct APIResult: Codable {
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
