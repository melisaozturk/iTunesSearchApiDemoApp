//
//  TestHelpers.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 5.10.2026.
//

import Foundation
@testable import iTunesSearchApiDemoApp

// MARK: - Test Spy for Cancellable
class CancellableTaskSpy: Cancellable {
    var cancelCalled = false

    func cancel() {
        cancelCalled = true
    }
}

enum ResponseData {
    static let softwares: [SoftwareResult] = [
        SoftwareResult(
            trackName: "Instagram",
            artworkUrl100: "",
            screenshotUrls: ["https://example.com/1.jpg"],
            artistName: "Instagram, Inc."
        ),
        SoftwareResult(
            trackName: "Facebook",
            artworkUrl100: "",
            screenshotUrls: ["https://example.com/2.jpg"],
            artistName: "Meta Platforms, Inc."
        )
    ]
}


enum TestError: Error {
    case networkEror
}
