//
//  APIError.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 2.10.2026.
//


import Foundation

/// API-specific errors for iTunes Search API
enum APIError: Error {
    case network(NetworkError)  // ← NetworkError wrap ediliyor
    case decoding(Error)        // ← API'ya özel
}

// MARK: - User-Friendly Messages
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

// MARK: - User-Presentable Messages
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
