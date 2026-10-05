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
    private let completion: (Result<UIImage, NetworkError>) -> Void
    
    private let stateLock = NSLock()
    private var task: URLSessionDataTask?
    private var _isExecuting = false
    private var _isFinished = false
    
    override var isAsynchronous: Bool { true }
    
    init(url: URL,
         session: URLSession = .shared,
         completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        self.url = url
        self.session = session
        self.completion = completion
        super.init()
    }
    
    override var isExecuting: Bool {
        stateLock.lock()
        defer { stateLock.unlock() }
        return _isExecuting
    }
    
    override var isFinished: Bool {
        stateLock.lock()
        defer { stateLock.unlock() }
        return _isFinished
    }
    
    // MARK: - Operation Lifecycle (Key-Value Observing notification)
    override func start() {
        guard !isCancelled else {
            completion(.failure(.cancelled))
            finish()
            return
        }
        
        willChangeValue(forKey: "isExecuting")
        
        stateLock.lock()
        _isExecuting = true
        stateLock.unlock()
        
        didChangeValue(forKey: "isExecuting")
        
        let dataTask = session.dataTask(with: url) { [weak self] data, response, error in
            guard let self else { return }
            
            defer { finish() }
            guard !isCancelled else {
                self.completion(.failure(.cancelled))
                return
            }
            
            if let urlError = error as? URLError, urlError.code == .cancelled {
                self.completion(.failure(.cancelled))
                return
            }
            
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
        
        if isCancelled {
            dataTask.cancel()
        }
        
        dataTask.resume()
    }
    
    override func cancel() {
        stateLock.lock()
        let wasFinished = _isFinished
        let runningTask = task
        stateLock.unlock()
        
        super.cancel()
        
        if !wasFinished {
            runningTask?.cancel()
        }
    }
    
    private func finish() {
        stateLock.lock()
        
        guard !_isFinished else {
            stateLock.unlock()
            return
        }
        
        let wasExecuting = _isExecuting
        stateLock.unlock()
        
        if wasExecuting {
            willChangeValue(forKey: "isExecuting")
            
            stateLock.lock()
            _isExecuting = false
            stateLock.unlock()
            
            didChangeValue(forKey: "isExecuting")
        }
        
        willChangeValue(forKey: "isFinished")
        
        stateLock.lock()
        _isFinished = true
        stateLock.unlock()
        
        didChangeValue(forKey: "isFinished")
    }
}

extension ImageDownloader: Cancellable {}
