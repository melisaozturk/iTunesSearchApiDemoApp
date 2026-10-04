//
//  NetworkError.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 4.10.2026.
//


import Foundation

/// Shared network layer error for all network operations
/// Used by both API calls (SearchWorker) and Image downloads (ImageDownloadManager)
enum NetworkError: Error {
    case invalidURL
    case networkFailure(Error)
    case cancelled
    case invalidResponse
    case httpStatus(Int)
    case invalidData
}

// MARK: - User-Friendly Messages
extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkFailure(let error):
            return "Network error: \(error.localizedDescription)"
        case .cancelled:
            return "Request cancelled"
        case .invalidResponse:
            return "Invalid response"
        case .httpStatus(let code):
            return "HTTP status \(code)"
        case .invalidData:
            return "Invalid data received"
        }
    }
}

// MARK: - User-Presentable Messages (for UI)
extension NetworkError {
    var userMessage: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkFailure:
            return "Network error. Please check your connection."
        case .cancelled:
            return "Request cancelled"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpStatus(let code):
            return "Server error (\(code))"
        case .invalidData:
            return "Failed to process data"
        }
    }
}
