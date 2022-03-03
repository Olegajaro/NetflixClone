//
//  NetworkService.swift
//  NetflixClone
//
//  Created by Олег Федоров on 02.03.2022.
//

import Foundation

enum APIError: Error {
    case failedToGetData
}

class NetworkService {
    
    func request(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func createDataTask(
        from request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, _, error in
            
            guard let data = data, error == nil else {
                if error != nil {
                    completion(.failure(APIError.failedToGetData))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }
    }
}
