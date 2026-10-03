//
//  SearchPresenter.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 2.10.2026.
//

protocol SearchPresentationDelegate {
    func presentSoftwares(response: Search.FetchSoftwares.Response)
    func presentLoading()
}

final class SearchPresenter: SearchPresentationDelegate {
    
    weak var viewController: SearchViewControllerDelegate?
    
    func presentSoftwares(response: Search.FetchSoftwares.Response) {
        if let error = response.error {
            let errorMessage = formatErrorMessage(error)
            let viewModel = Search.FetchSoftwares.ViewModel(
                softwares: [],
                isEmpty: true,
                errorMessage: errorMessage
            )
            viewController?.displaySoftwares(viewModel: viewModel)
            return
        }
        
        guard let softwares = response.softwares else {return }
        
        if softwares.isEmpty {
            let viewModel = Search.FetchSoftwares.ViewModel(
                softwares: [],
                isEmpty: true,
                errorMessage: "No results found"
            )
            viewController?.displaySoftwares(viewModel: viewModel)
            return
        }
        
        let displayedSoftwares = softwares.map { software in
            Search.FetchSoftwares.ViewModel.DisplayedSoftware(
                trackId: software.trackId,
                name: software.trackName ?? "",
                artistName: software.artistName ?? "",
                iconUrl: software.artworkUrl100 ?? "",
                screenshotUrls: software.screenshotUrls ?? []
            )
        }
        
        let viewModel = Search.FetchSoftwares.ViewModel(
            softwares: displayedSoftwares,
            isEmpty: false,
            errorMessage: nil
        )
        
        viewController?.displaySoftwares(viewModel: viewModel)
    }
    
    func presentLoading() {
        viewController?.displayLoading()
    }
    
    // MARK: - Private Helpers
    private func formatErrorMessage(_ error: APIError) -> String {
        switch error {
        case .networkError:
            return "Network error. Please check your connection."
        case .cancelled:
            return "Search cancelled"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpStatus(let code):
            return "Server error (\(code))"
        case .decoding:
            return "Failed to process results"
        }
    }
}
