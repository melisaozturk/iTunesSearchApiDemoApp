//
//  SearchPresenter.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 2.10.2026.
//

import Foundation

protocol SearchPresentationLogic: AnyObject {
    func presentSoftwares(response: Search.FetchSoftwares.Response)
    func presentLoading()
}

final class SearchPresenter: SearchPresentationLogic {
    
    private enum Constants {
        static let displayError: String = "No results found."
    }
    
    weak var viewController: SearchDisplayLogic?
    
    func presentSoftwares(response: Search.FetchSoftwares.Response) {
        if let error = response.error {
            let errorMessage = error.userMessage
            viewController?.displayError(message: errorMessage)
            return
        }
        
        if response.softwares.isEmpty {
            viewController?.displayError(message: Constants.displayError)
            return
        }
        
        let displayedSoftwares = response.softwares.map { software in
            Search.FetchSoftwares.ViewModel.DisplayedSoftware(
                name: software.trackName ?? "",
                artistName: software.artistName ?? "",
                screenshotUrls: software.screenshotUrls ?? []
            )
        }
        
        viewController?.displaySoftwares(viewModel: .init(softwares: displayedSoftwares))
    }
    
    func presentLoading() {
        viewController?.displayLoading()
    }
}
