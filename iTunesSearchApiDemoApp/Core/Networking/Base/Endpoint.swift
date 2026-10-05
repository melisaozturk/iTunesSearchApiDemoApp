//
//  Endpoint.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 2.10.2026.
//

import Foundation

protocol Endpoint {
    var base: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    var urlComponents: URLComponents? {
        guard var components = URLComponents(string: base) else { return nil }
        components.path = path
        components.queryItems = queryItems
        return components
    }
    
    var request: URLRequest? {
        guard let url = urlComponents?.url else { return nil }
        return URLRequest(url: url)
    }
}
