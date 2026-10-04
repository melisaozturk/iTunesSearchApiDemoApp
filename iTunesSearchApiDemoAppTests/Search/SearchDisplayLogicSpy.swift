//
//  SearchDisplayLogicSpy.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 5.10.2026.
//

@testable import iTunesSearchApiDemoApp

class SearchDisplayLogicSpy: SearchDisplayLogic {
    var displaySoftwaresCalled = false
    var displayLoadingCalled = false
    var displayErrorCalled = false

    var displayedViewModel: Search.FetchSoftwares.ViewModel?
    var displayedErrorMessage: String?

    func displaySoftwares(viewModel: Search.FetchSoftwares.ViewModel) {
        displaySoftwaresCalled = true
        displayedViewModel = viewModel
    }

    func displayLoading() {
        displayLoadingCalled = true
    }

    func displayError(message: String) {
        displayErrorCalled = true
        displayedErrorMessage = message
    }
}
