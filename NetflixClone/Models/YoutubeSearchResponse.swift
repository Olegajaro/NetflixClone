//
//  YoutubeSearchResults.swift
//  NetflixClone
//
//  Created by Олег Федоров on 04.03.2022.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}

/*
 items =     (
             {
         etag = VKOyN8toIz07mDXIleFAkShLtqk;
         id =             {
             kind = "youtube#video";
             videoId = "-1iaJWSwUZs";
         };
         kind = "youtube#searchResult";
     }
 */
