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
    var apiClientMock: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClientMock = MockAPIClient()
        sut = SearchWorker(apiClient: apiClientMock)
    }

    override func tearDown() {
        sut = nil
        apiClientMock = nil
        super.tearDown()
    }
        
    func testSearchSoftwares_WithValidJSON_ShouldReturnSoftwares() {
        let json = """
        {"results":[{"trackName":"Instagram","artistName":"Meta","screenshotUrls":["https://example.com/1.jpg"]}]}
        """
        apiClientMock.result = .success(Data(json.utf8))
        var received: Result<[SoftwareResult], APIError>?
        
        _ = sut.searchSoftwares(term: "Instagram") { received = $0 }

        guard case .success(let list)? = received else { return XCTFail("Başarı bekleniyordu") }
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list.first?.trackName, "Instagram")
        XCTAssertEqual(list.first?.screenshotUrls, ["https://example.com/1.jpg"])
    }
    
    func testSearchSoftwares_WithNetworkError_ShouldPropagateError() {
          apiClientMock.result = .failure(.network(.httpStatus(500)))
          var received: Result<[SoftwareResult], APIError>?

          _ = sut.searchSoftwares(term: "x") { received = $0 }

          guard case .failure(.network(.httpStatus(let code)))? = received else {
              return XCTFail("HTTP hatası bekleniyordu")
          }
          XCTAssertEqual(code, 500)
      }
    
    func testClearImageCache_ShouldRemoveCachedImages() {
          let url = URL(string: "https://example.com/a.jpg")!
          ImageCache.shared.store(UIImage(systemName: "star")!, for: url)

          sut.clearImageCache()

          XCTAssertNil(ImageCache.shared.memoryImage(for: url))
      }
}
