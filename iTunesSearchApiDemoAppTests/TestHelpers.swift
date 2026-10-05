//
//  TestHelpers.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 5.10.2026.
//

import Foundation
@testable import iTunesSearchApiDemoApp

// MARK: Cancellable Mock
class MockCancellableTask: Cancellable {
    var cancelCalled = false

    func cancel() {
        cancelCalled = true
    }
}

// MARK: Response Mock
enum ResponseData {
    static let softwares: [SoftwareResult] = [
        SoftwareResult(
            trackName: "Instagram",
            screenshotUrls: ["https://example.com/1.jpg"],
            artistName: "Instagram"
        )
    ]
}
