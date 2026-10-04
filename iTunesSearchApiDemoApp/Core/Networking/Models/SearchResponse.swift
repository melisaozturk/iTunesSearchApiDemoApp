//
//  SearchResponse.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 3.10.2026.
//

import Foundation

struct SearchResponse: Decodable {
    let results: [SoftwareResult]?
}

struct SoftwareResult: Decodable {    
    let trackName: String?
    let artworkUrl100: String?
    let screenshotUrls: [String]?
    let artistName: String?
}
