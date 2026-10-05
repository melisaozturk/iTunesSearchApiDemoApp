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

    // Aynı URL'i bekleyen herkesin callback'i burada tutulur
    private var callbacks: [URL: [UUID: Completion]] = [:]
    private var activeDownloads: [URL: ImageDownloader] = [:]
    private let lock = NSLock()

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

    // MARK: - Private
    private func enqueueDownload(for url: URL) {
        lock.lock()
        guard callbacks[url]?.isEmpty == false, activeDownloads[url] == nil else {
            lock.unlock()
            return
        }

        let operation = ImageDownloader(url: url, session: session) { [weak self] result in
            guard let self else { return }

            // İptal sadece removeCallback'ten gelir ve orada state zaten temizlenmiştir.
            // Burada deliver çağırırsak aynı URL için sonradan başlamış yeni indirmeyi bozarız.
            if case .failure(.cancelled) = result { return }

            if case .success(let image) = result {
                self.cache.store(image, for: url)
            }
            self.deliver(result, for: url)
        }
        activeDownloads[url] = operation
        lock.unlock()

        downloadQueue.addOperation(operation)
    }

    private func deliver(_ result: Result<UIImage, NetworkError>, for url: URL) {
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

    // MARK: - Public Methods

    /// Completion her zaman main thread'de çağrılır.
    /// Dönen token cancel edildiğinde sadece bu çağıranın callback'i kaldırılır;
    /// başka bekleyen yoksa indirme de iptal edilir.
    
    @discardableResult
    func downloadImage(from urlString: String, completion: @escaping Completion) -> Cancellable? {
        // ✅ Case 1: Invalid URL → MAIN THREAD
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                completion(.failure(.invalidURL))
            }
            return nil
        }

        // ✅ Case 2: Cache Hit → MAIN THREAD
        if let image = cache.memoryImage(for: url) {
            DispatchQueue.main.async {
                completion(.success(image))
            }
            return nil
        }

        // ✅ Case 3: Download → MAIN THREAD (zaten var, değişiklik yok)
        // Line 67-69'da DispatchQueue.main.async ile garantileniyor

        // 2. Callback'i kaydet; bu URL için ilk istekse yüklemeyi başlat
        let token = UUID()
        lock.lock()
        let isFirstRequest = callbacks[url] == nil
        callbacks[url, default: [:]][token] = completion
        lock.unlock()

        if isFirstRequest {
            enqueueDownload(for: url)
        }

        return DownloadToken { [weak self] in
            self?.removeCallback(token, for: url)
        }
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
        onCancel = nil
    }
}
