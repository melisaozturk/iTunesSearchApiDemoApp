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
    var viewControllerSpy: SearchDisplayLogicSpy!

    override func setUp() {
        super.setUp()
        setupSearchPresenter()
    }

    override func tearDown() {
        sut = nil
        viewControllerSpy = nil
        super.tearDown()
    }

    func setupSearchPresenter() {
        sut = SearchPresenter()
        viewControllerSpy = SearchDisplayLogicSpy()
        sut.viewController = viewControllerSpy
    }

    func testPresentSoftwares_WithEmptyArray_ShouldDisplayError() {
        let response = Search.FetchSoftwares.Response(softwares: [], error: nil)

        sut.presentSoftwares(response: response)
        
        XCTAssertTrue(viewControllerSpy.displayErrorCalled)
        XCTAssertEqual(viewControllerSpy.displayedErrorMessage, "No results found")
    }

    func testPresentSoftwares_WithValidSoftwares_ShouldDisplaySoftwares() {      
        let response = Search.FetchSoftwares.Response(
            softwares: ResponseData.softwares,
            error: nil
        )
        
        sut.presentSoftwares(response: response)

        XCTAssertTrue(viewControllerSpy.displaySoftwaresCalled)
        XCTAssertEqual(viewControllerSpy.displayedViewModel?.softwares?.count, 2)
        XCTAssertEqual(viewControllerSpy.displayedViewModel?.isEmpty, false)

        let firstApp = viewControllerSpy.displayedViewModel?.softwares?.first
        XCTAssertEqual(firstApp?.name, "Instagram")
        XCTAssertEqual(firstApp?.artistName, "Instagram, Inc.")
        XCTAssertEqual(firstApp?.screenshotUrls?.count, 1)
    }

    func testPresentLoading_ShouldCallViewController() {
        sut.presentLoading()

        XCTAssertTrue(viewControllerSpy.displayLoadingCalled)
    }
}
