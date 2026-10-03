//
//  SearchResponse.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 3.10.2026.
//

import Foundation

struct SearchResponse: Decodable {
    let resultCount: Int?
    let results: [SoftwareResult]?
}

struct SoftwareResult: Decodable {
    let trackId: Int
    let trackName: String?
    let artworkUrl100: String?
    let artworkUrl512: String?
    let screenshotUrls: [String]?
    let artistName: String?
    let averageUserRating: Double?
    let userRatingCount: Int?
    let description: String?
}
