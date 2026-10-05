//
//  PreviewWorker.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 4.10.2026.
//

import UIKit

protocol PreviewWorkerLogic: AnyObject {
    func loadImage(url: String,
                   completion: @escaping (Result<UIImage, NetworkError>) -> Void) -> Cancellable?
}

final class PreviewWorker: PreviewWorkerLogic {

    private let imageDownloadManager: ImageDownloadManager

    init(imageDownloadManager: ImageDownloadManager = .shared) {
        self.imageDownloadManager = imageDownloadManager
    }

    func loadImage(url: String,
                   completion: @escaping (Result<UIImage, NetworkError>) -> Void) -> Cancellable? {
        imageDownloadManager.downloadImage(from: url, completion: completion)
    }
}
