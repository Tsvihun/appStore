//
//  AppGroup.swift
//  AppStore
//
//  Created by Лилия on 08.11.2021.
//

import Foundation


struct AppGroup: Decodable, Hashable {
    let feed: Feed
}

struct Feed: Decodable, Hashable {
    let title: String
    let results: [FeedResult]
}

struct FeedResult: Decodable, Hashable {
    let id, name, artistName, artworkUrl100, url: String
}
