//
//  SearchPresenter.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 2.10.2026.
//

import Foundation

protocol SearchPresentationLogic {
    func presentSoftwares(response: Search.FetchSoftwares.Response)
    func presentLoading()
}

final class SearchPresenter: SearchPresentationLogic {

    weak var viewController: SearchDisplayLogic?

    func presentSoftwares(response: Search.FetchSoftwares.Response) {
        // SearchInteractor zaten main thread'de çağrıyor
        // ERROR CASE
        if let error = response.error {
            let errorMessage = error.userMessage
            viewController?.displayError(message: errorMessage)
            return
        }

        // NO DATA CASE
        guard let softwares = response.softwares else { return }

        // EMPTY RESULTS CASE
        if softwares.isEmpty {
            viewController?.displayError(message: "No results found")
            return
        }

        // SUCCESS CASE
        let displayedSoftwares = softwares.map { software in
            Search.FetchSoftwares.ViewModel.DisplayedSoftware(
                name: software.trackName ?? "",
                artistName: software.artistName ?? "",
                screenshotUrls: software.screenshotUrls ?? []
            )
        }

        let viewModel = Search.FetchSoftwares.ViewModel(
            softwares: displayedSoftwares,
            isEmpty: false
        )

        viewController?.displaySoftwares(viewModel: viewModel)
    }

    func presentLoading() {
        viewController?.displayLoading()
    }
}
