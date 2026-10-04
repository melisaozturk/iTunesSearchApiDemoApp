//
//  SearchInteractor.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 2.10.2026.
//

import Foundation
import UIKit

protocol SearchBusinessLogic {
    func fetchSoftwares(request: Search.FetchSoftwares.Request)
    func cancelSearch()
    func handleMemoryWarning()
    @discardableResult
    func loadImage(
        url: String,
        completion: @escaping (
            Result<UIImage, NetworkError>
        ) -> Void
    ) -> Cancellable?
}

final class SearchInteractor: SearchBusinessLogic {
    var presenter: SearchPresentationLogic?
    var worker: SearchWorkerLogic?
    
    private var currentSearchTask: Cancellable?
    
    deinit {
        currentSearchTask?.cancel()
    }
    
    // MARK: - Business Logic
    func fetchSoftwares(request: Search.FetchSoftwares.Request) {
        currentSearchTask?.cancel()
        
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
                    // Yeni arama eskisini iptal etti; ekranda "Search cancelled" göstermeye gerek yok
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
    }
    
    func handleMemoryWarning() {
        worker?.clearImageCache()
    }
    
    @discardableResult
    func loadImage(url: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) -> Cancellable? {
        return worker?.loadImage(url: url, completion: completion)
    }
}

