//
//  SearchWorkerTests.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 5.10.2026.
//

import XCTest
@testable import iTunesSearchApiDemoApp

final class SearchWorkerTests: XCTestCase {

    // MARK: - System Under Test
    var sut: SearchWorker!
    var apiClientSpy: APIClientSpy!

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        sut = nil
        apiClientSpy = nil
        super.tearDown()
    }
}
