//
//  PreviewWorker.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 4.10.2026.
//

import UIKit

protocol PreviewWorkerLogic {
    @discardableResult
    func loadImage(url: String,
                   completion: @escaping (Result<UIImage, NetworkError>) -> Void) -> Cancellable?
    // ← NetworkError (Error yerine)
}

final class PreviewWorker: PreviewWorkerLogic {

    @discardableResult
    func loadImage(url: String,
                   completion: @escaping (Result<UIImage, NetworkError>) -> Void) -> Cancellable? {
        // ImageDownloadManager NetworkError döndürüyor artık
        return ImageDownloadManager.shared.downloadImage(from: url, completion: completion)
    }
}
