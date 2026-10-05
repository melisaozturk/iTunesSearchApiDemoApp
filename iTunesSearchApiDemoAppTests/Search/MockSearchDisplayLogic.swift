//
//  MockSearchDisplayLogic.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 5.10.2026.
//

@testable import iTunesSearchApiDemoApp

class MockSearchDisplayLogic: SearchDisplayLogic {
    var displaySoftwaresCalled = false
    var displayLoadingCalled = false
    var displayErrorCalled = false

    var displaySoftwaresCallCount = 0
    var displayLoadingCallCount = 0
    var displayErrorCallCount = 0

    var displayedViewModel: Search.FetchSoftwares.ViewModel?
    var displayedErrorMessage: String?

    func displaySoftwares(viewModel: Search.FetchSoftwares.ViewModel) {
        displaySoftwaresCalled = true
        displaySoftwaresCallCount += 1
        displayedViewModel = viewModel
    }

    func displayLoading() {
        displayLoadingCalled = true
        displayLoadingCallCount += 1
    }

    func displayError(message: String) {
        displayErrorCalled = true
        displayErrorCallCount += 1
        displayedErrorMessage = message
    }
}
