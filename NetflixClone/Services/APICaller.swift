//
//  APICaller.swift
//  NetflixClone
//
//  Created by Олег Федоров on 02.03.2022.
//

import Foundation

struct Constans {
    static let API_KEY = "APIKEY_tmdb"
    static let API_KEY_YOUTUBE = "APIKEY_youtube"
    static let baseURL = "https://api.themoviedb.org"
    static let youtubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
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
    
    func getDiscoverMovies(completion: @escaping (TitleResponse?) -> Void) {
        networkDataFetcher.fetchGenericJSONData(
            url: "\(Constans.baseURL)/3/discover/movie?api_key=\(Constans.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate",
            response: completion
        )
    }
    
    func search(with query: String, completion: @escaping (TitleResponse?) -> Void) {
        guard
            let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        else { return }
        
        networkDataFetcher.fetchGenericJSONData(
            url: "\(Constans.baseURL)/3/search/movie?api_key=\(Constans.API_KEY)&query=\(query)",
            response: completion
        )
    }
    
    func getMovie(with query: String, completion: @escaping (YoutubeSearchResponse?) -> Void) {
        guard
            let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        else { return }
        
        networkDataFetcher.fetchGenericJSONData(
            url: "\(Constans.youtubeBaseURL)q=\(query)&key=\(Constans.API_KEY_YOUTUBE)",
            response: completion
        )
    }
}
