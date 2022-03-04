//
//  APICaller.swift
//  NetflixClone
//
//  Created by Олег Федоров on 02.03.2022.
//

import Foundation

struct Constans {
    static let API_KEY = "e03261ca92ace993fcd082703951db23"
    static let API_KEY_YOUTUBE = "AIzaSyDJvnnPsM-laLz7tO7H6X-W8B4eH3uKcnU"
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
    
    func getMovie(with query: String) {
        guard
            let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        else { return }
        
        let stringUrl = "\(Constans.youtubeBaseURL)q=\(query)&key=\(Constans.API_KEY_YOUTUBE)"
        
        guard let url = URL(string: stringUrl) else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                print(results)
            } catch  {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
}
 
// https://api.themoviedb.org/3/movie/upcoming?api_key=e03261ca92ace993fcd082703951db23&language=en-US&page=1

// https://api.themoviedb.org/3/movie/popular?api_key=e03261ca92ace993fcd082703951db23&language=en-US&page=1

// https://api.themoviedb.org/3/movie/top_rated?api_key=e03261ca92ace993fcd082703951db23&language=en-US&page=1

// https://api.themoviedb.org/3/discover/movie?api_key=e03261ca92ace993fcd082703951db23&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate

// https://api.themoviedb.org/3/search/movie?api_key={api_key}&query=Jack+Reacher

// https://youtube.googleapis.com/youtube/v3/search?q=Harry&key=AIzaSyDJvnnPsM-laLz7tO7H6X-W8B4eH3uKcnU
