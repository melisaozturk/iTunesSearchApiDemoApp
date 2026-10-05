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
        sut = SearchInteractor()
        presenterMock = MockSearchPresentationLogic()
        workerMock = MockSearchWorkerLogic()
        
        sut.presenter = presenterMock
        sut.worker = workerMock
    }
    
    override func tearDown() {
        sut = nil
        presenterMock = nil
        workerMock = nil
        super.tearDown()
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
    
    func testFetchSoftwares_ShouldCancelPrefetchDownloads() {

        sut.fetchSoftwares(request: .init(searchTerm: "Instagram"))
        
        // Then
        XCTAssertEqual(workerMock.cancelPrefetchDownloadsCallCount, 1)
    }
}
