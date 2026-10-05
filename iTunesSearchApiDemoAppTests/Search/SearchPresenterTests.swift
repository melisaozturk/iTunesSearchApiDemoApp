//
//  SearchPresenterTests.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 5.10.2026.
//

import XCTest
@testable import iTunesSearchApiDemoApp

final class SearchPresenterTests: XCTestCase {

    var sut: SearchPresenter!
    var viewControllerMock: MockSearchDisplayLogic!

    override func setUp() {
        super.setUp()
        setupSearchPresenter()
    }

    override func tearDown() {
        sut = nil
        viewControllerMock = nil
        super.tearDown()
    }

    func setupSearchPresenter() {
        sut = SearchPresenter()
        viewControllerMock = SearchDisplayLogicMock()
        sut.viewController = viewControllerMock
    }

    func testPresentSoftwares_WithEmptyArray_ShouldDisplayError() {
        let response = Search.FetchSoftwares.Response(softwares: [], error: nil)

        sut.presentSoftwares(response: response)
        
        XCTAssertTrue(viewControllerMock.displayErrorCalled)
        XCTAssertEqual(
            viewControllerMock.displayedErrorMessage,
            "No results found"
        )
    }

    func testPresentSoftwares_WithValidSoftwares_ShouldDisplaySoftwares() {      
        let response = Search.FetchSoftwares.Response(
            softwares: ResponseData.softwares,
            error: nil
        )
        
        sut.presentSoftwares(response: response)

        XCTAssertTrue(viewControllerMock.displaySoftwaresCalled)
        XCTAssertEqual(viewControllerMock.displayedViewModel?.softwares?.count, 2)
        XCTAssertEqual(viewControllerMock.displayedViewModel?.isEmpty, false)

        let firstApp = viewControllerMock.displayedViewModel?.softwares?.first
        XCTAssertEqual(firstApp?.name, "Instagram")
        XCTAssertEqual(firstApp?.artistName, "Instagram, Inc.")
        XCTAssertEqual(firstApp?.screenshotUrls?.count, 1)
    }

    func testPresentLoading_ShouldCallViewController() {
        sut.presentLoading()

        XCTAssertTrue(viewControllerMock.displayLoadingCalled)
    }
}
