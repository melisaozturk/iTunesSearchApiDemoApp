//
//  SearchWorker.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 2.10.2026.
//

import Foundation
import UIKit

protocol SearchWorkerLogic {
    func searchSoftwares(term: String, completion: @escaping (Result<[SoftwareResult], APIError>) -> Void) -> Cancellable?
    func clearImageCache()
    @discardableResult
    func loadImage(url: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) -> Cancellable?
    @discardableResult
    func prefetchImage(url: String) -> Cancellable?
}
 
final class SearchWorker: SearchWorkerLogic {
    private let apiClient: APIClient
 
    init(apiClient: APIClient = URLSessionAPIClient()) {
        self.apiClient = apiClient
    }
    
    func clearImageCache() {
        ImageCache.shared.clearMemory()
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
    
    @discardableResult
     func loadImage(url: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) -> Cancellable? {
         return ImageDownloadManager.shared.downloadImage(from: url, completion: completion)
     }
    
    @discardableResult
    func prefetchImage(url: String) -> Cancellable? {
        // Prefetch için completion gereksiz
        return ImageDownloadManager.shared.downloadImage(from: url)  { (_: Result<UIImage, NetworkError>) in }
    }
}
 
