//
//  MockSearchPresentationLogic.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 5.10.2026.
//

@testable import iTunesSearchApiDemoApp

class MockSearchPresentationLogic: SearchPresentationLogic {
    var presentSoftwaresCalled = false
    var presentLoadingCalled = false
    var presentedResponse: Search.FetchSoftwares.Response?

    var presentSoftwaresCallCount = 0
    var presentLoadingCallCount = 0

    func presentSoftwares(response: Search.FetchSoftwares.Response) {
        presentSoftwaresCalled = true
        presentSoftwaresCallCount += 1
        presentedResponse = response
    }

    func presentLoading() {
        presentLoadingCalled = true
        presentLoadingCallCount += 1
    }
}
