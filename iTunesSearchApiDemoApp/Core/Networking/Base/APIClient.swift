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
    func send(_ request: URLRequest,
              completion: @escaping (Result<Data, APIError>) -> Void) -> Cancellable
}

extension APIClient {
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
