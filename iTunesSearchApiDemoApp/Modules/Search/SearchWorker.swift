//
//  SearchWorker.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 2.10.2026.
//

import Foundation

protocol SearchWorkerDelegate {
    func searchSoftwares(term: String, completion: @escaping (Result<[SoftwareResult], APIError>) -> Void) -> Cancellable?
}
 
final class SearchWorker: SearchWorkerDelegate {
    private let apiClient: APIClient
 
    init(apiClient: APIClient = URLSessionAPIClient()) {
        self.apiClient = apiClient
    }
 
    @discardableResult
    func searchSoftwares(term: String, completion: @escaping (Result<[SoftwareResult], APIError>) -> Void) -> Cancellable? {
        guard !term.isEmpty else {
            completion(.success([]))
            return nil
        }
 
        let endpoint = SearchEndpoint.search(term: term)
 
        return apiClient.fetch(SearchResponse.self, request: endpoint.request) { result in
            // results nil gelse bile completion mutlaka çağrılmalı
            completion(result.map { $0.results ?? [] })
        }
    }
}
 
