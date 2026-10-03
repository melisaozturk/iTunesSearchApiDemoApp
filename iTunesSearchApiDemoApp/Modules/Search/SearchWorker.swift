//
//  SearchWorker.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 2.10.2026.
//

import Foundation

protocol SearchWorkerProtocol {
    func searchApps(term: String, completion: @escaping (Result<[SoftwareResult], APIError>) -> Void)
}

final class SearchWorker: SearchWorkerProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient = URLSessionAPIClient()) {
        self.apiClient = apiClient
    }

    func searchApps(term: String, completion: @escaping (Result<[SoftwareResult], APIError>) -> Void) {
        guard !term.isEmpty else {
            completion(.success([]))
            return
        }

        let endpoint = SearchEndpoints.search(term: term)

        apiClient.fetch(
            SearchResponse.self,
            request: endpoint.request
        ) { result in
            switch result {
            case .success(let response):
                completion(
                    .success(response.results!)
                ) // TODO: response.results fix
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
