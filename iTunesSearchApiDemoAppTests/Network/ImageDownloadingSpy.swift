////
////  ImageDownloadingSpy.swift
////  iTunesSearchApiDemoApp
////
////  Created by Melisa Öztürk on 5.10.2026.
////
//
//@testable import iTunesSearchApiDemoApp
//
//class ImageDownloadingProtocolSpy: ImageDownloadingProtocol {
//      var downloadImageCalled = false
//      var downloadCallCount = 0
//      var downloadedURLs: [String] = []
//      var lastDownloadedURL: String?
//      var downloadResult: Result<UIImage, NetworkError>?
//
//      func downloadImage(from urlString: String,
//                        completion: @escaping (Result<UIImage, NetworkError>) -> Void) -> Cancellable? {
//          downloadImageCalled = true
//          downloadCallCount += 1
//          downloadedURLs.append(urlString)
//          lastDownloadedURL = urlString
//
//          if let result = downloadResult {
//              DispatchQueue.main.async {
//                  completion(result)
//              }
//          }
//
//          return CancellableTaskSpy()
//      }
//  }
