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
    private init() { }
    
    func getTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        
        guard
            let url = URL(string: "\(Constans.baseURL)/3/trending/all/day?api_key=\(Constans.API_KEY)")
        else { return }

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }

            do {
                let results = try JSONDecoder().decode(
                    TrendingMoviesResponse.self,
                    from: data
                )
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
 
