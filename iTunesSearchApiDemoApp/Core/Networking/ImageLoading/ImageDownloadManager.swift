//
//  ImageDownloadManager.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 3.10.2026.
//

import UIKit

final class ImageDownloadManager {
    
    static let shared = ImageDownloadManager()
    typealias Completion = (Result<UIImage, NetworkError>) -> Void
    
    // MARK: - Properties
    private let cache: ImageCache
    private let session: URLSession
    private let downloadQueue: OperationQueue
    
    private init(cache: ImageCache = .shared,
                 session: URLSession = .shared,
                 maxConcurrentDownloads: Int = 3) {
        self.cache = cache
        self.session = session
        downloadQueue = OperationQueue()
        downloadQueue.maxConcurrentOperationCount = maxConcurrentDownloads
        downloadQueue.qualityOfService = .userInitiated
        downloadQueue.name = "com.itunes.imageDownloadQueue"
    }
    
    @discardableResult
    func downloadImage(from urlString: String, completion: @escaping Completion) -> Cancellable? {
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async { completion(.failure(.invalidURL)) }
            return nil
        }
        
        if let image = cache.memoryImage(for: url) {
            DispatchQueue.main.async { completion(.success(image)) }
            return nil
        }
        
        let operation = ImageDownloader(url: url, session: session) { [weak self] result in
            if case .failure(.cancelled) = result { return }
            
            if case .success(let image) = result {
                self?.cache.store(image, for: url)
            }
            DispatchQueue.main.async { completion(result) }
        }
        
        downloadQueue.addOperation(operation)
        return operation
    }
}
