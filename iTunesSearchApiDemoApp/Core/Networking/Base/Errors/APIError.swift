//
//  APIError.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 2.10.2026.
//

import Foundation

enum APIError: Error {
    case network(NetworkError)
    case decoding(Error)
}

// MARK: - Messages
extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .network(let networkError):
            return networkError.errorDescription
        case .decoding(let error):
            return "Decoding failed: \(error)"
        }
    }
}

extension APIError {
    var userMessage: String {
        switch self {
        case .network(let networkError):
            return networkError.userMessage
        case .decoding:
            return "Failed to process results"
        }
    }
}
