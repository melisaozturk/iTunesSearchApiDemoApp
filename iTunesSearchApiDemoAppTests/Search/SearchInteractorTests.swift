//
//  SearchInteractorTests.swift
//  iTunesSearchApiDemoAppTests
//
//  Created by Melisa Öztürk on 5.10.2026.
//

import XCTest
@testable import iTunesSearchApiDemoApp

final class SearchInteractorTests: XCTestCase {
    private var sut: SearchInteractor!
    private var presenterSpy: SearchPresentationLogicSpy!
    private var workerSpy: SearchWorkerLogicSpy!

    // MARK: - Test Lifecycle

    override func setUp() {
        super.setUp()
        setupSearchInteractor()
    }

    override func tearDown() {
        sut = nil
        presenterSpy = nil
        workerSpy = nil
        super.tearDown()
    }

    // MARK: - Test Setup

    func setupSearchInteractor() {
        sut = SearchInteractor()
        presenterSpy = SearchPresentationLogicSpy()
        workerSpy = SearchWorkerLogicSpy()

        sut.presenter = presenterSpy
        sut.worker = workerSpy
    }

    // MARK: - Tests - fetchSoftwares

    func testFetchSoftwares_WithSuccessfulResponse_ShouldPresentSoftwares() {
        // Given
        let request = Search.FetchSoftwares.Request(searchTerm: "Instagram")
        let expectedSoftwares = ResponseData.softwares
        workerSpy.searchResult = .success(expectedSoftwares)

        let expectation = self.expectation(description: "Wait for async completion")

        // When
        sut.fetchSoftwares(request: request)

        // Simulate async callback
        DispatchQueue.main.async {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)

        // Then
        XCTAssertTrue(presenterSpy.presentSoftwaresCalled)
        XCTAssertEqual(presenterSpy.presentedResponse?.softwares?.count, expectedSoftwares.count)
        XCTAssertNil(presenterSpy.presentedResponse?.error)
    }

    func testFetchSoftwares_WithNetworkError_ShouldPresentError() {
        // Given
        let request = Search.FetchSoftwares.Request(searchTerm: "Instagram")
        let expectedError = APIError.network(
            .networkFailure(TestError.networkEror)
        )
        workerSpy.searchResult = .failure(expectedError)

        let expectation = self.expectation(description: "Wait for async completion")

        // When
        sut.fetchSoftwares(request: request)

        DispatchQueue.main.async {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)

        // Then
        XCTAssertTrue(presenterSpy.presentSoftwaresCalled)
        XCTAssertNotNil(presenterSpy.presentedResponse?.error)
        XCTAssertEqual(presenterSpy.presentedResponse?.softwares?.count, 0)
    }

    func testCancelSearch_ShouldCancelCurrentTask() {
        // Given
        let request = Search.FetchSoftwares.Request(searchTerm: "Instagram")
        sut.fetchSoftwares(request: request)

        // When
        sut.cancelSearch()

        // Then
        XCTAssertTrue(workerSpy.cancelledTasks.count > 0)
    }

    func testHandleMemoryWarning_ShouldClearImageCache() {
        // When
        sut.handleMemoryWarning()

        // Then
        XCTAssertTrue(workerSpy.clearImageCacheCalled)
    }
}
