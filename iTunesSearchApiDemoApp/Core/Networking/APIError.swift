//
//  APIError.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 2.10.2026.
//

import Foundation

enum APIError: Error {
    case networkError(Error)
    case cancelled
    case invalidResponse
    case httpStatus(Int)
    case decoding(Error)
}

// Log description
extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .networkError(
            let error
        ): return "Network error: \(error.localizedDescription)"
        case .cancelled:            return "Request cancelled"
        case .invalidResponse:      return "Invalid response"
        case .httpStatus(let code): return "HTTP status \(code)"
        case .decoding(let error):  return "Decoding failed: \(error)"
        }
    }
}
