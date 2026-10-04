//
//  ImageDownloader.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 3.10.2026.
//

import UIKit

final class ImageDownloader: Operation, @unchecked Sendable {
    
    // MARK: - Properties
    
    private let url: URL
    private let session: URLSession
    private let completion: (Result<UIImage, NetworkError>) -> Void  // ← NetworkError
    
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
         completion: @escaping (Result<UIImage, NetworkError>) -> Void) {  // ← NetworkError
        self.url = url
        self.session = session
        self.completion = completion
        super.init()
    }
    
    // MARK: - Operation Lifecycle
    
    override func start() {
        // Atomic cancelled check + executing state set
        stateLock.lock()
        let wasCancelled = isCancelled
        if !wasCancelled {
            _isExecuting = true
        }
        stateLock.unlock()
        
        // Eğer cancelled, temizle ve çık
        guard !wasCancelled else {
            completion(.failure(.cancelled))
            finish()
            return
        }
        
        // KVO notification (state zaten değişti)
        willChangeValue(forKey: "isExecuting")
        didChangeValue(forKey: "isExecuting")
        
        let dataTask = session.dataTask(with: url) { [self] data, response, error in
            defer { finish() }
            guard !isCancelled else { return }
            
            if let error {
                self.completion(.failure(.networkFailure(error)))
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                self.completion(.failure(.invalidData))
                return
            }
            
            self.completion(.success(image))
        }
        
        stateLock.lock()
        task = dataTask
        stateLock.unlock()
        
        dataTask.resume()
    }
    
    override func cancel() {
        // State check önce (lock içinde)
        stateLock.lock()
        let wasFinished = _isFinished
        let runningTask = task
        stateLock.unlock()
        
        // isCancelled flag'i set et
        super.cancel()
        
        // Sadece henüz bitmemişse cancel et
        if !wasFinished {
            runningTask?.cancel()
        }
    }
    
    
    // MARK: - KVO helpers
    
    private func finish() {
        // Atomic state transition (check + set tek lock içinde)
        stateLock.lock()
        
        guard !_isFinished else {
            stateLock.unlock()
            return
        }
        
        let wasExecuting = _isExecuting
        
        // State değişimi lock içinde (KVO henüz yok)
        _isExecuting = false
        _isFinished = true
        
        stateLock.unlock()
        
        // KVO notifications lock dışında (deadlock önleme)
        if wasExecuting {
            willChangeValue(forKey: "isExecuting")
            didChangeValue(forKey: "isExecuting")
        }
        willChangeValue(forKey: "isFinished")
        didChangeValue(forKey: "isFinished")
    }
}
