//
//  SearchPresenterTests.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 5.10.2026.
//

import XCTest
@testable import iTunesSearchApiDemoApp

final class SearchPresenterTests: XCTestCase {

    var searchPresenter: SearchPresenter!
    var viewControllerMock: MockSearchDisplayLogic!

    override func setUp() {
        super.setUp()
        setupSearchPresenter()
    }

    override func tearDown() {
        searchPresenter = nil
        viewControllerMock = nil
        super.tearDown()
    }

    func setupSearchPresenter() {
        searchPresenter = SearchPresenter()
        viewControllerMock = MockSearchDisplayLogic()
        searchPresenter.viewController = viewControllerMock
    }

    func testPresentSoftwares_WithEmptyArray_ShouldDisplayError() {
        let response = Search.FetchSoftwares.Response(softwares: [], error: nil)

        searchPresenter.presentSoftwares(response: response)
        
        XCTAssertTrue(viewControllerMock.displayErrorCalled)
        XCTAssertEqual(
            viewControllerMock.displayedErrorMessage,
            "No results found."
        )
    }

    func testPresentSoftwares_WithValidSoftwares_ShouldDisplaySoftwares() {      
        let response = Search.FetchSoftwares.Response(
            softwares: ResponseData.softwares,
            error: nil
        )
        
        searchPresenter.presentSoftwares(response: response)

        XCTAssertTrue(viewControllerMock.displaySoftwaresCalled)
        XCTAssertEqual(viewControllerMock.displayedViewModel?.softwares.count, 1)

        let firstApp = viewControllerMock.displayedViewModel?.softwares.first
        XCTAssertEqual(firstApp?.name, "Instagram")
        XCTAssertEqual(firstApp?.artistName, "Instagram")
        XCTAssertEqual(firstApp?.screenshotUrls.count, 1)
    }

    func testPresentLoading_ShouldCallViewController() {
        searchPresenter.presentLoading()

        XCTAssertTrue(viewControllerMock.displayLoadingCalled)
    }
}
