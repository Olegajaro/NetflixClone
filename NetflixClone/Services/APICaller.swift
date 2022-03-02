//
//  APICaller.swift
//  NetflixClone
//
//  Created by Олег Федоров on 02.03.2022.
//

import Foundation

struct Constans {
    static let API_KEY = "e03261ca92ace993fcd082703951db23"
    static let baseURL = "https://api.themoviedb.org"
}

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    static let shared = APICaller()
    
    var networkDataFetcher: NetworkDataFetcher!
    
    private init (networkDataFetcher: NetworkDataFetcher = NetworkDataFetcher()) {
        self.networkDataFetcher = networkDataFetcher
    }
    
    func getTrendingMovies(completion: @escaping (TrendingMoviesResponse?) -> Void) {
        networkDataFetcher.fetchGenericJSONData(
            url: "\(Constans.baseURL)/3/trending/movie/day?api_key=\(Constans.API_KEY)",
            response: completion
        )
    }
    
    func getTrendingTvs(completion: @escaping (TrendingTvsResponse?) -> Void) {
        networkDataFetcher.fetchGenericJSONData(
            url: "\(Constans.baseURL)/3/trending/tv/day?api_key=\(Constans.API_KEY)",
            response: completion
        )
    }
}
 
