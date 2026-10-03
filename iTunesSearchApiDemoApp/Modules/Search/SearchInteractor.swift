//
//  SearchInteractor.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 2.10.2026.
//

import Foundation

protocol SearchInteractorDelegate {
    func fetchSoftwares(request: Search.FetchSoftwares.Request)
    func cancelSearch()
}
 
final class SearchInteractor: SearchInteractorDelegate {
    var presenter: SearchPresentationDelegate?
    var worker: SearchWorkerDelegate?
 
    private var currentSearchTask: Cancellable?
 
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
                    self.presenter?.presentSoftwares(response: .init(softwares: softwares, error: nil))
 
                case .failure(.cancelled):
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
}
 
