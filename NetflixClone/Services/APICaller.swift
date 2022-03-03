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

class APICaller {
    static let shared = APICaller()
    
    var networkDataFetcher: NetworkDataFetcher!
    
    private init (networkDataFetcher: NetworkDataFetcher = NetworkDataFetcher()) {
        self.networkDataFetcher = networkDataFetcher
    }
    
    func getTrendingMovies(completion: @escaping (TitleResponse?) -> Void) {
        networkDataFetcher.fetchGenericJSONData(
            url: "\(Constans.baseURL)/3/trending/movie/day?api_key=\(Constans.API_KEY)",
            response: completion
        )
    }
    
    func getTrendingTvs(completion: @escaping (TitleResponse?) -> Void) {
        networkDataFetcher.fetchGenericJSONData(
            url: "\(Constans.baseURL)/3/trending/tv/day?api_key=\(Constans.API_KEY)",
            response: completion
        )
    }
    
    func getPopularMovies(completion: @escaping (TitleResponse?) -> Void) {
        networkDataFetcher.fetchGenericJSONData(
            url: "\(Constans.baseURL)/3/movie/popular?api_key=\(Constans.API_KEY)&language=en-US&page=1",
            response: completion
        )
    }
    
    func getUpcomingMovies(completion: @escaping (TitleResponse?) -> Void) {
        networkDataFetcher.fetchGenericJSONData(
            url: "\(Constans.baseURL)/3/movie/upcoming?api_key=\(Constans.API_KEY)&language=en-US&page=1",
            response: completion
        )
    }
    
    func getTopRatedMovies(completion: @escaping (TitleResponse?) -> Void) {
        networkDataFetcher.fetchGenericJSONData(
            url: "\(Constans.baseURL)/3/movie/top_rated?api_key=\(Constans.API_KEY)&language=en-US&page=1",
            response: completion
        )
    }
}
 
// https://api.themoviedb.org/3/movie/upcoming?api_key=e03261ca92ace993fcd082703951db23&language=en-US&page=1

// https://api.themoviedb.org/3/movie/popular?api_key=e03261ca92ace993fcd082703951db23&language=en-US&page=1

// https://api.themoviedb.org/3/movie/top_rated?api_key=e03261ca92ace993fcd082703951db23&language=en-US&page=1
