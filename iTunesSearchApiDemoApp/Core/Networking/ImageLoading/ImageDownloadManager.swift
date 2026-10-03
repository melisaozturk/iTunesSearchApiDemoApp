//
//  ImageDownloadManager.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 3.10.2026.
//

import UIKit

final class ImageDownloadManager {
 
    static let shared = ImageDownloadManager()
 
    typealias Completion = (Result<UIImage, Error>) -> Void
 
    // MARK: - Properties
 
    private let cache: ImageCache
    private let session: URLSession
    private let downloadQueue: OperationQueue
 
    // Aynı URL'i bekleyen herkesin callback'i burada tutulur
    private var callbacks: [URL: [UUID: Completion]] = [:]
    private var activeDownloads: [URL: ImageDownloader] = [:]
    private let lock = NSLock()
 
    // MARK: - Init
 
    init(cache: ImageCache = .shared,
         session: URLSession = .shared,
         maxConcurrentDownloads: Int = 3) {
        self.cache = cache
        self.session = session
        downloadQueue = OperationQueue()
        downloadQueue.maxConcurrentOperationCount = maxConcurrentDownloads
        downloadQueue.qualityOfService = .userInitiated
        downloadQueue.name = "com.itunes.imageDownloadQueue"
    }
 
    // MARK: - Public Methods
 
    /// Completion her zaman main thread'de çağrılır.
    /// Dönen token cancel edildiğinde sadece bu çağıranın callback'i kaldırılır;
    /// başka bekleyen yoksa indirme de iptal edilir.
    @discardableResult
    func downloadImage(from urlString: String, completion: @escaping Completion) -> Cancellable? {
        guard let url = URL(string: urlString) else {
            completion(.failure(ImageDownloadError.invalidURL))
            return nil
        }
 
        // 1. Memory cache (senkron)
        if let image = cache.memoryImage(for: url) {
            completion(.success(image))
            return nil
        }
 
        // 2. Callback'i kaydet; bu URL için ilk istekse yüklemeyi başlat
        let token = UUID()
        lock.lock()
        let isFirstRequest = callbacks[url] == nil
        callbacks[url, default: [:]][token] = completion
        lock.unlock()
 
        if isFirstRequest {
            loadFromDiskOrNetwork(url)
        }
 
        return DownloadToken { [weak self] in
            self?.removeCallback(token, for: url)
        }
    }
 
    func cancelAllDownloads() {
        lock.lock()
        callbacks.removeAll()
        activeDownloads.removeAll()
        lock.unlock()
        downloadQueue.cancelAllOperations()
    }
 
    // MARK: - Private
 
    private func loadFromDiskOrNetwork(_ url: URL) {
        cache.diskImage(for: url) { [weak self] image in
            guard let self else { return }
            if let image {
                self.deliver(.success(image), for: url)
            } else {
                self.enqueueDownload(for: url)
            }
        }
    }
 
    private func enqueueDownload(for url: URL) {
        lock.lock()
        // Disk okunurken herkes iptal ettiyse ya da zaten indiriliyorsa başlatma
        guard callbacks[url]?.isEmpty == false, activeDownloads[url] == nil else {
            lock.unlock()
            return
        }
 
        let operation = ImageDownloader(url: url, session: session) { [weak self] result in
            guard let self else { return }
            if case .success(let image) = result {
                self.cache.store(image, for: url)
            }
            self.deliver(result, for: url)
        }
        activeDownloads[url] = operation
        lock.unlock()
 
        downloadQueue.addOperation(operation)
    }
 
    private func deliver(_ result: Result<UIImage, Error>, for url: URL) {
        lock.lock()
        let handlers = callbacks.removeValue(forKey: url).map { Array($0.values) } ?? []
        activeDownloads.removeValue(forKey: url)
        lock.unlock()
 
        guard !handlers.isEmpty else { return }
        DispatchQueue.main.async {
            handlers.forEach { $0(result) }
        }
    }
 
    private func removeCallback(_ token: UUID, for url: URL) {
        lock.lock()
        callbacks[url]?.removeValue(forKey: token)
 
        var operationToCancel: ImageDownloader?
        if callbacks[url]?.isEmpty == true {
            callbacks.removeValue(forKey: url)
            operationToCancel = activeDownloads.removeValue(forKey: url)
        }
        lock.unlock()
 
        operationToCancel?.cancel()
    }
}
 
// MARK: - DownloadToken
 
private final class DownloadToken: Cancellable {
    private var onCancel: (() -> Void)?
 
    init(onCancel: @escaping () -> Void) {
        self.onCancel = onCancel
    }
 
    func cancel() {
        onCancel?()
        onCancel = nil // birden fazla cancel çağrısı zararsız olsun
    }
}
 
