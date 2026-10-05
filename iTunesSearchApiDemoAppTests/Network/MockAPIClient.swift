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

//
//class MockAPIClient: APIClient {
//    var sendCalled = false
//    var sendCallCount = 0
//    var sentRequest: URLRequest?
//
//    var fetchCalled = false
//    var fetchCallCount = 0
//    var fetchedType: Any.Type?
//    var fetchedRequest: URLRequest?
//
//    var sendResult: Result<Data, APIError>?
//    private var fetchResultHandler: Any?
//
//    @discardableResult
//    func send(_ request: URLRequest,
//              completion: @escaping (Result<Data, APIError>) -> Void) -> Cancellable {
//        sendCalled = true
//        sendCallCount += 1
//        sentRequest = request
//
//        if let result = sendResult {
//            DispatchQueue.main.async {
//                completion(result)
//            }
//        }
//
//        return MockCancellableTask()
//    }
//
//    func setSendResult(_ result: Result<Data, APIError>) {
//        sendResult = result
//    }
//}
