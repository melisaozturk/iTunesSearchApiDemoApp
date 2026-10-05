//
//  SearchEndpoint.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 3.10.2026.
//

import Foundation

enum SearchEndpoint {
    case search(term: String)
}

extension SearchEndpoint: Endpoint {
    
    var base: String {
        return "https://itunes.apple.com"
        
    }

    var path: String {
        switch self {
        case .search: return "/search"
        }
    }
        
    var queryItem: [URLQueryItem] {
        switch self {
        case .search(let searchTerm):
            return [
                URLQueryItem(name: "term", value: searchTerm),
                URLQueryItem(name: "media", value: "software")
            ]
        }
    }
    
}
