//
//  NetworkDataFetcher.swift
//  NetflixClone
//
//  Created by Олег Федоров on 02.03.2022.
//

import Foundation

class NetworkDataFetcher {
    
    var networkService: NetworkService!
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchGenericJSONData<T: Codable>(
        url: String, response: @escaping (T?) -> Void
    ) {
        
        networkService.request(url: url) { result in
            switch result {
            case .success(let data):
                let decoded = self.decodeJSON(type: T.self, from: data)
                response(decoded)
//                print("DEBUG: decoded: \(String(describing: decoded))")
            case .failure(let error):
                print(error.localizedDescription)
                response(nil)
            }
        }
    }
    
    private func decodeJSON<T: Codable>(type: T.Type, from data: Data) -> T? {
        
        let decoder = JSONDecoder()
            
        do {
            let objects = try decoder.decode(type.self, from: data)
//            print("DEBUG: object: \(objects)")
            return objects
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
}
