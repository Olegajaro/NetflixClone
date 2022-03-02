//
//  Tv.swift
//  NetflixClone
//
//  Created by Олег Федоров on 02.03.2022.
//

import Foundation

struct TrendingTvsResponse: Codable {
    let results: [Tv]
}

struct Tv: Codable {
    let id: Int
    let originalName: String?
    let firstAirDate: String?
    let posterPath: String?
    let overview: String?
    let voteAverage: Double
    let mediaType: String?
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case originalName = "original_name"
        case firstAirDate = "first_air_date"
        case posterPath = "poster_path"
        case overview
        case voteAverage = "vote_average"
        case mediaType = "media_type"
        case voteCount = "vote_count"
    }
}

/*
 {
       "poster_path": "/izIMqapegdEZj0YVDyFATPR8adh.jpg",
       "original_name": "Vikings: Valhalla",
       "origin_country": [
         "US"
       ],
       "name": "Vikings: Valhalla",
       "vote_count": 43,
       "first_air_date": "2022-02-25",
       "backdrop_path": "/k47JEUTQsSMN532HRg6RCzZKBdB.jpg",
       "vote_average": 8.3,
       "genre_ids": [
         10759,
         18,
         10768
       ],
       "id": 116135,
       "original_language": "en",
       "overview": "In this sequel to \"Vikings,\" a hundred years have passed and a new generation of legendary heroes arises to forge its own destiny — and make history.",
       "popularity": 901.075,
       "media_type": "tv"
     }
 */
