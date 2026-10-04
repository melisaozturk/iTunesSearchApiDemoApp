//TODO: APIClientMock
//  APIClientSpy.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 5.10.2026.
//

@testable import iTunesSearchApiDemoApp
import Foundation

class APIClientSpy: APIClient {

    // MARK: - Tracking Properties
    var sendCalled = false
    var sendCallCount = 0
    var sentRequest: URLRequest?

    var fetchCalled = false
    var fetchCallCount = 0
    var fetchedType: Any.Type?
    var fetchedRequest: URLRequest?

    // MARK: - Result Storage
    var sendResult: Result<Data, APIError>?
    private var fetchResultHandler: Any?

    // MARK: - APIClient Protocol (REQUIRED)

    @discardableResult
    func send(_ request: URLRequest,
              completion: @escaping (Result<Data, APIError>) -> Void) -> Cancellable {
        sendCalled = true
        sendCallCount += 1
        sentRequest = request

        if let result = sendResult {
            DispatchQueue.main.async {
                completion(result)
            }
        }

        return CancellableTaskSpy()
    }

    // MARK: - Helper Methods for Tests

    /// Set result for fetch<T> calls
//    func setFetchResult<T: Decodable>(_ result: Result<T, APIError>) {
//        // Convert to Data result for send()
//        switch result {
//        case .success(let value):
//            do {
//                let data = try JSONEncoder().encode(value)
//                sendResult = .success(data)
//            } catch {
//                sendResult = .failure(.decoding(error))
//            }
//        case .failure(let error):
//            sendResult = .failure(error)
//        }
//    }

    /// Set raw data result for send() calls
    func setSendResult(_ result: Result<Data, APIError>) {
        sendResult = result
    }
}
