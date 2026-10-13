//
//  SearchWorker.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 2.10.2026.
//

import Foundation
import UIKit

protocol SearchWorkerLogic: AnyObject {
    func searchSoftwares(term: String,
                         completion: @escaping (Result<[SoftwareResult], APIError>) -> Void) -> Cancellable?
    func clearImageCache()
    func downloadImages(urls: [String])
    func cancelPrefetchDownloads()
    func loadImage(url: String,
                   completion: @escaping (Result<UIImage, NetworkError>) -> Void) -> Cancellable?
    func addFavorite(url: String)
    func removeFavorite(url: String)
    func favoriteUrls() -> [String]
}

final class SearchWorker: SearchWorkerLogic {
    private let apiClient: APIClient
    private var prefetchDownloadTasks: [Cancellable] = []
    private let favoritesManager: FavoritesManagerProtocol

    init(apiClient: APIClient = URLSessionAPIClient(),
         favoritesManager: FavoritesManagerProtocol = FavoritesManager.shared) {
        self.apiClient = apiClient
        self.favoritesManager = favoritesManager
    }
    
    deinit {
        cancelPrefetchDownloads()
    }
    
    func clearImageCache() {
        ImageCache.shared.clearMemory()
    }
    
    func searchSoftwares(term: String,
                         completion: @escaping (Result<[SoftwareResult], APIError>) -> Void) -> Cancellable? {
        guard !term.isEmpty else {
            completion(.success([]))
            return nil
        }
                
        guard let request = SearchEndpoint.search(term: term).request else {
               completion(.failure(.network(.invalidURL)))
               return nil
           }
        
        return apiClient.fetch(SearchResponse.self,
                               request: request) { result in
            completion(result.map { $0.results ?? [] })
        }
    }
    
    func downloadImages(urls: [String]) {
        cancelPrefetchDownloads()
        prefetchDownloadTasks = urls.compactMap { url in
            ImageDownloadManager.shared.downloadImage(from: url) { _ in }
        }
    }
    
    func cancelPrefetchDownloads() {
        prefetchDownloadTasks.forEach { $0.cancel() }
        prefetchDownloadTasks.removeAll()
    }
    
    func loadImage(url: String,
                   completion: @escaping (Result<UIImage, NetworkError>) -> Void) -> Cancellable? {
        ImageDownloadManager.shared.downloadImage(from: url, completion: completion)
    }
    
    func addFavorite(url: String) {
        favoritesManager.add(url: url)
    }
    
    func removeFavorite(url: String) {
        favoritesManager.remove(url: url)
    }
    
    func favoriteUrls() -> [String] {
        favoritesManager.favorites
    }
}
