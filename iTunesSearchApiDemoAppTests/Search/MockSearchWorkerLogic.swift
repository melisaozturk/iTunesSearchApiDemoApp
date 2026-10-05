//
//  MockSearchWorkerLogic.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 5.10.2026.
//

@testable import iTunesSearchApiDemoApp
import Foundation
import UIKit

class MockSearchWorkerLogic: SearchWorkerLogic {
    var searchSoftwaresCalled = false
    var searchTerm: String?
    var searchResult: Result<[SoftwareResult], APIError>?
    var cancelledTasks: [Cancellable] = []

    var clearImageCacheCalled = false
    var downloadImagesCalled = false
    var downloadedImageURLs: [String] = []

    var loadImageCalled = false
    var loadImageURL: String?
    private var loadImageCompletion: ((Result<UIImage, NetworkError>) -> Void)?

    func searchSoftwares(term: String,
                         completion: @escaping (Result<[SoftwareResult], APIError>) -> Void) -> Cancellable? {
        searchSoftwaresCalled = true
        searchTerm = term

        if let result = searchResult {
            DispatchQueue.main.async {
                completion(result)
            }
        }

        let task = MockCancellableTask()
        cancelledTasks.append(task)
        return task
    }

    func clearImageCache() {
        clearImageCacheCalled = true
    }
    
    var cancelPrefetchDownloadsCallCount = 0

    func cancelPrefetchDownloads() {
        cancelPrefetchDownloadsCallCount += 1
    }
    
    func downloadImages(urls: [String]) {
        downloadImagesCalled = true
        downloadedImageURLs = urls
    }

    func loadImage(url: String,
                   completion: @escaping (Result<UIImage, NetworkError>) -> Void) -> Cancellable? {
        loadImageCalled = true
        loadImageURL = url
        loadImageCompletion = completion
        return MockCancellableTask()
    }
}
