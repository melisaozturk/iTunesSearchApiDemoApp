//
//  SearchInteractorTests.swift
//  iTunesSearchApiDemoAppTests
//
//  Created by Melisa Öztürk on 5.10.2026.
//

import XCTest
@testable import iTunesSearchApiDemoApp

final class SearchInteractorTests: XCTestCase {
    private var searchInteractor: SearchInteractor!
    private var presenterMock: MockSearchPresentationLogic!
    private var workerMock: MockSearchWorkerLogic!
    
    override func setUp() {
        super.setUp()
        searchInteractor = SearchInteractor()
        presenterMock = MockSearchPresentationLogic()
        workerMock = MockSearchWorkerLogic()
        
        searchInteractor.presenter = presenterMock
        searchInteractor.worker = workerMock
    }
    
    override func tearDown() {
        searchInteractor = nil
        presenterMock = nil
        workerMock = nil
        super.tearDown()
    }
    
    func testCancelSearch_ShouldCancelCurrentTask() {
        let request = Search.FetchSoftwares.Request(searchTerm: "Instagram")
        searchInteractor.fetchSoftwares(request: request)
        
        searchInteractor.cancelSearch()
                
        XCTAssertTrue(workerMock.cancelledTasks.count > 0)
    }
    
    func testHandleMemoryWarning_ShouldClearImageCache() {
        searchInteractor.handleMemoryWarning()
        
        XCTAssertTrue(workerMock.clearImageCacheCalled)
    }
    
    func testFetchSoftwares_ShouldCancelPrefetchDownloads() {
        searchInteractor.fetchSoftwares(request: .init(searchTerm: "Instagram"))
        
        XCTAssertEqual(workerMock.cancelPrefetchDownloadsCallCount, 1)
    }
}
