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
            
            if let error = error as? URLError, error.code == .cancelled {
                return completion(.failure(.network(.cancelled)))
            }

            if let error {
                return completion(.failure(.network(.networkFailure(error))))
            }

            guard let http = response as? HTTPURLResponse, let data else {
                return completion(.failure(.network(.invalidResponse)))
            }

            guard (200..<300).contains(http.statusCode) else {
                return completion(.failure(.network(.httpStatus(http.statusCode))))
            }

            completion(.success(data))
        }
        task.resume()
        return task
    }
}
