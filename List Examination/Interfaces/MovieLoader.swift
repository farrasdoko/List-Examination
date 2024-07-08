//
//  MovieLoader.swift
//  List Examination
//
//  Created by Farras on 08/07/24.
//

import Foundation

enum LoadMovieResult {
    case success(APIResult)
    case failed(RemoteMovieLoader.Error)
}

protocol MovieLoader {
    func fetchMovie() async -> LoadMovieResult
}
