//
//  SearchPresentationLogicSpy.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 5.10.2026.
//

@testable import iTunesSearchApiDemoApp

class SearchPresentationLogicSpy: SearchPresentationLogic {
    var presentSoftwaresCalled = false
    var presentLoadingCalled = false
    var presentedResponse: Search.FetchSoftwares.Response?

    func presentSoftwares(response: Search.FetchSoftwares.Response) {
        presentSoftwaresCalled = true
        presentedResponse = response
    }

    func presentLoading() {
        presentLoadingCalled = true
    }
}
