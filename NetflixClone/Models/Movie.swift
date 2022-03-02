//
//  Movie.swift
//  NetflixClone
//
//  Created by Олег Федоров on 02.03.2022.
//

import Foundation

struct TrendingMoviesResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let mediaType: String?
    let originalTitle: String?
    let originalName: String?
    let posterPath: String?
    let overview: String?
    let voteCount: Int
    let releaseDate: String?
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case mediaType = "media_type"
        case originalTitle = "original_title"
        case originalName = "original_name"
        case posterPath = "poster_path"
        case overview
        case voteCount = "vote_count"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}

/*
 {
       "id": 414906,
       "adult": false,
       "backdrop_path": "/e66tM5YOawXLxhDAfWkR7sxpb3h.jpg",
       "genre_ids": [
         28,
         80,
         18
       ],
       "vote_count": 68,
       "original_language": "en",
       "original_title": "The Batman",
       "poster_path": "/74xTEgt7R36Fpooo50r9T25onhq.jpg",
       "title": "The Batman",
       "video": false,
       "vote_average": 8.1,
       "release_date": "2022-03-01",
       "overview": "In his second year of fighting crime, Batman uncovers corruption in Gotham City that connects to his own family while facing a serial killer known as the Riddler.",
       "popularity": 1196.961,
       "media_type": "movie"
     }
 */
