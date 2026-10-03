//
//  ImageDownloader.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 3.10.2026.
//

import UIKit
 
enum ImageDownloadError: Error {
    case invalidURL
    case invalidData
}

final class ImageDownloader: Operation, @unchecked Sendable {
 
    // MARK: - Properties
 
    private let url: URL
    private let session: URLSession
    private let completion: (Result<UIImage, Error>) -> Void
 
    // Durum farklı thread'lerden okunup yazıldığı için lock ile korunuyor
    private let stateLock = NSLock()
    private var task: URLSessionDataTask?
    private var _isExecuting = false
    private var _isFinished = false
 
    override var isAsynchronous: Bool { true }
 
    override var isExecuting: Bool {
        stateLock.lock(); defer { stateLock.unlock() }
        return _isExecuting
    }
 
    override var isFinished: Bool {
        stateLock.lock(); defer { stateLock.unlock() }
        return _isFinished
    }
 
    // MARK: - Init
 
    init(url: URL,
         session: URLSession = .shared,
         completion: @escaping (Result<UIImage, Error>) -> Void) {
        self.url = url
        self.session = session
        self.completion = completion
        super.init()
    }
 
    // MARK: - Operation Lifecycle
 
    override func start() {
        // İptal edilmiş operation'lar da queue tarafından start edilir; sadece bitiriyoruz
        guard !isCancelled else {
            finish()
            return
        }
 
        setExecuting(true)
 
        let dataTask = session.dataTask(with: url) { [self] data, _, error in
            defer { finish() }
 
            // İptal edildiyse kimseye haber verme (manager callback'leri zaten kaldırdı)
            guard !isCancelled else { return }
 
            if let error {
                completion(.failure(error))
                return
            }
 
            guard let data, let image = UIImage(data: data) else {
                completion(.failure(ImageDownloadError.invalidData))
                return
            }
 
            completion(.success(image))
        }
 
        stateLock.lock()
        task = dataTask
        stateLock.unlock()
 
        dataTask.resume()
    }
 
    override func cancel() {
        super.cancel()
        stateLock.lock()
        let runningTask = task
        stateLock.unlock()
        // finish() burada çağrılmıyor: çalışıyorsa dataTask callback'i, çalışmıyorsa start() bitirir
        runningTask?.cancel()
    }
 
    // MARK: - KVO helpers
 
    private func setExecuting(_ value: Bool) {
        willChangeValue(forKey: "isExecuting")
        stateLock.lock(); _isExecuting = value; stateLock.unlock()
        didChangeValue(forKey: "isExecuting")
    }
 
    private func setFinished(_ value: Bool) {
        willChangeValue(forKey: "isFinished")
        stateLock.lock(); _isFinished = value; stateLock.unlock()
        didChangeValue(forKey: "isFinished")
    }
 
    private func finish() {
        guard !isFinished else { return }
        if isExecuting { setExecuting(false) }
        setFinished(true)
    }
}
 
