//
//  URLSessionAPIClient.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 5.10.2026.
//

import Foundation

final class URLSessionAPIClient: APIClient {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func send(_ request: URLRequest,
              completion: @escaping (Result<Data, APIError>) -> Void) -> Cancellable {
        let task = session.dataTask(with: request) { data, response, error in
            // Cancelled
            if let error = error as? URLError, error.code == .cancelled {
                return completion(.failure(.network(.cancelled)))  // ← NetworkError wrap
            }

            // Network error
            if let error {
                return completion(.failure(.network(.networkFailure(error))))  // ← NetworkError wrap
            }

            // Invalid response
            guard let http = response as? HTTPURLResponse, let data else {
                return completion(.failure(.network(.invalidResponse)))  // ← NetworkError wrap
            }

            // HTTP status error
            guard (200..<300).contains(http.statusCode) else {
                return completion(.failure(.network(.httpStatus(http.statusCode))))  // ← NetworkError wrap
            }

            // Success
            completion(.success(data))
        }
        task.resume()
        return task
    }
}
