//
//  SearchResult.swift
//  AppStore
//
//  Created by Лилия on 04.11.2021.
//

import Foundation


struct SearchResult: Decodable {
  let resultCount: Int
  let results: [Result]
}

struct Result: Decodable {
    let trackId: Int
    let trackName: String
    let primaryGenreName: String
    var trackViewUrl: String?
    var averageUserRating: Double?
    var userRatingCount: Int?
    var screenshotUrls: [String]?
    let artworkUrl100: String // app icon
    var formattedPrice: String?
    var description: String?
    var releaseNotes: String?
    var artistName: String?
    var collectionName: String?
}
