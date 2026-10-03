//
//  APIClient.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 2.10.2026.
//

import Foundation

protocol Cancellable {
    func cancel()
}

extension URLSessionDataTask: Cancellable {}

protocol APIClient {
    @discardableResult
    func send(_ request: URLRequest,
              completion: @escaping (Result<Data, APIError>) -> Void) -> Cancellable
}

extension APIClient {
    @discardableResult
    func fetch<T: Decodable>(_ type: T.Type,
                             request: URLRequest,
                             decoder: JSONDecoder = JSONDecoder(),
                             completion: @escaping (Result<T, APIError>) -> Void) -> Cancellable {
        send(request) { result in
            completion(result.flatMap { data in
                do { return .success(try decoder.decode(T.self, from: data)) }
                catch { return .failure(.decoding(error)) }
            })
        }
    }
}

final class URLSessionAPIClient: APIClient {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func send(_ request: URLRequest,
              completion: @escaping (Result<Data, APIError>) -> Void) -> Cancellable {
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error as? URLError, error.code == .cancelled {
                return completion(.failure(.cancelled))
            }
            if let error { return completion(.failure(.networkError(error))) }
            guard let http = response as? HTTPURLResponse, let data else {
                return completion(.failure(.invalidResponse))
            }
            guard (200..<300).contains(http.statusCode) else {
                return completion(.failure(.httpStatus(http.statusCode)))
            }
            // TODO: Add other cases
            completion(.success(data))
        }
        task.resume()
        return task
    }
}
