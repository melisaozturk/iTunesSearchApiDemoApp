//
//  MockAPIClient.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 5.10.2026.
//

@testable import iTunesSearchApiDemoApp
import Foundation

final class MockAPIClient: APIClient {
    var result: Result<Data, APIError>?
    var sentRequests: [URLRequest] = []
    let task = MockCancellableTask()

    func send(_ request: URLRequest,
              completion: @escaping (Result<Data, APIError>) -> Void) -> Cancellable {
        sentRequests.append(request)
        if let result { completion(result) }
        return task
    }
}
