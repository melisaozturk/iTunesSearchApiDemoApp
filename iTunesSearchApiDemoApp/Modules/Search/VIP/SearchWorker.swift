//
//  SearchWorker.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 2.10.2026.
//

import Foundation
import UIKit

protocol SearchWorkerLogic {
    func searchSoftwares(term: String,
                         completion: @escaping (Result<[SoftwareResult], APIError>) -> Void) -> Cancellable?
    func clearImageCache()
    func downloadImages(urls: [String])
    func cancelPrefetchDownloads()
    @discardableResult
    func loadImage(url: String,
                   completion: @escaping (Result<UIImage, NetworkError>) -> Void) -> Cancellable?
}

final class SearchWorker: SearchWorkerLogic {
    private let apiClient: APIClient
    private var prefetchDownloadTasks: [Cancellable] = []
    private let lock = NSLock()

    init(apiClient: APIClient = URLSessionAPIClient()) {
        self.apiClient = apiClient
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

        let endpoint = SearchEndpoint.search(term: term)

        return apiClient.fetch(
            SearchResponse.self,
            request: endpoint.request
        ) { result in
            completion(result.map { $0.results ?? [] })
        }
    }

    func downloadImages(urls: [String]) {
        // 1. Yeni prefetch'leri başlat (lock dışında)
        let newTasks = urls.compactMap { url in
            ImageDownloadManager.shared.downloadImage(from: url) { _ in
                // ImageDownloadManager cache'e kaydediyor.
            }
        }

        // 2. Eski seti yenisiyle atomik değiştir
        lock.lock()
        let oldTasks = prefetchDownloadTasks
        prefetchDownloadTasks = newTasks
        lock.unlock()

        // 3. Eskileri lock dışında iptal et
        oldTasks.forEach { $0.cancel() }
    }

    func cancelPrefetchDownloads() {
        lock.lock()
        let tasks = prefetchDownloadTasks
        prefetchDownloadTasks.removeAll()
        lock.unlock()

        tasks.forEach { $0.cancel() }
    }

    @discardableResult
    func loadImage(url: String,
                   completion: @escaping (Result<UIImage, NetworkError>) -> Void) -> Cancellable? {
        ImageDownloadManager.shared.downloadImage(from: url, completion: completion)
    }
}
