//
//  SearchInteractor.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 2.10.2026.
//

import Foundation
import UIKit

protocol SearchBusinessLogic: AnyObject {
    func fetchSoftwares(request: Search.FetchSoftwares.Request)
    func cancelSearch()
    func handleMemoryWarning()
    func loadImage(url: String,
                   completion: @escaping (Result<UIImage, NetworkError>) -> Void) -> Cancellable?
}

final class SearchInteractor: SearchBusinessLogic {
    var presenter: SearchPresentationLogic?
    var worker: SearchWorkerLogic?
    
    private var currentSearchTask: Cancellable?
    
    deinit {
        currentSearchTask?.cancel()
        worker?.cancelPrefetchDownloads()
    }
    
    // MARK: - Business Logic
    func fetchSoftwares(request: Search.FetchSoftwares.Request) {
        currentSearchTask?.cancel()
        worker?.cancelPrefetchDownloads()
        
        guard let searchTerm = request.searchTerm, !searchTerm.isEmpty else {
            presenter?.presentSoftwares(response: .init(softwares: [], error: nil))
            return
        }
        
        presenter?.presentLoading()
        
        currentSearchTask = worker?.searchSoftwares(term: searchTerm) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                
                switch result {
                case .success(let softwares):
                    
                    let imageURLs = softwares
                        .flatMap { $0.screenshotUrls ?? [] }
                    
                    self.worker?.downloadImages(urls: imageURLs)
                    
                    self.presenter?.presentSoftwares( response: .init(
                        softwares: softwares,
                        error: nil))
                case .failure(.network(.cancelled)):
                    return
                    
                case .failure(let error):
                    self.presenter?.presentSoftwares(response: .init(softwares: [], error: error))
                }
            }
        }
    }
    
    func cancelSearch() {
        currentSearchTask?.cancel()
        currentSearchTask = nil
        worker?.cancelPrefetchDownloads()
    }
    
    func handleMemoryWarning() {
        worker?.clearImageCache()
        worker?.cancelPrefetchDownloads()
    }
    
    func loadImage(url: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) -> Cancellable? {
        return worker?.loadImage(url: url, completion: completion)
    }
}

