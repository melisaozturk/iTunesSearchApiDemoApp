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
    private var presenterMock: MockSearchPresentationLogic!
    private var workerMock: MockSearchWorkerLogic!

    // MARK: - Test Lifecycle

    override func setUp() {
        super.setUp()
        setupSearchInteractor()
    }

    override func tearDown() {
        sut = nil
        presenterMock = nil
        workerMock = nil
        super.tearDown()
    }

    // MARK: - Test Setup

    func setupSearchInteractor() {
        sut = SearchInteractor()
        presenterMock = MockSearchPresentationLogic()
        workerMock = MockSearchWorkerLogic()

        sut.presenter = presenterMock
        sut.worker = workerMock
    }

    // MARK: - Tests - fetchSoftwares

    func testFetchSoftwares_WithSuccessfulResponse_ShouldPresentSoftwares() {
        // Given
        let request = Search.FetchSoftwares.Request(searchTerm: "Instagram")
        let expectedSoftwares = ResponseData.softwares
        workerMock.searchResult = .success(expectedSoftwares)

        let expectation = self.expectation(description: "Wait for async completion")

        // When
        sut.fetchSoftwares(request: request)

        // Simulate async callback
        DispatchQueue.main.async {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)

        // Then
        XCTAssertTrue(presenterMock.presentSoftwaresCalled)
        XCTAssertEqual(
            presenterMock.presentedResponse?.softwares?.count,
            expectedSoftwares.count
        )
        XCTAssertNil(presenterMock.presentedResponse?.error)
    }

    func testFetchSoftwares_WithNetworkError_ShouldPresentError() {
        // Given
        let request = Search.FetchSoftwares.Request(searchTerm: "Instagram")
        let expectedError = APIError.network(
            .networkFailure(TestError.networkEror)
        )
        workerMock.searchResult = .failure(expectedError)

        let expectation = self.expectation(description: "Wait for async completion")

        // When
        sut.fetchSoftwares(request: request)

        DispatchQueue.main.async {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)

        // Then
        XCTAssertTrue(presenterMock.presentSoftwaresCalled)
        XCTAssertNotNil(presenterMock.presentedResponse?.error)
        XCTAssertEqual(presenterMock.presentedResponse?.softwares?.count, 0)
    }

    func testCancelSearch_ShouldCancelCurrentTask() {
        // Given
        let request = Search.FetchSoftwares.Request(searchTerm: "Instagram")
        sut.fetchSoftwares(request: request)

        // When
        sut.cancelSearch()

        // Then
        XCTAssertTrue(workerMock.cancelledTasks.count > 0)
    }

    func testHandleMemoryWarning_ShouldClearImageCache() {
        // When
        sut.handleMemoryWarning()

        // Then
        XCTAssertTrue(workerMock.clearImageCacheCalled)
    }
}
