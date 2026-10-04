//
//  PreviewInteractor.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 4.10.2026.
//


import UIKit

// MARK: - Business Logic Protocol
protocol PreviewBusinessLogic {
    func loadImage()
}

final class PreviewInteractor: PreviewBusinessLogic {

    // MARK: - VIP Properties
    var presenter: PreviewPresentationLogic?
    var worker: PreviewWorkerLogic?

    // MARK: - Private Properties
    private let imageUrl: String
    private var downloadTask: Cancellable?

    // MARK: - Initialization
    init(imageUrl: String) {
        self.imageUrl = imageUrl
    }

    // MARK: - Business Logic
    func loadImage() {
        // 1. Presenter'a loading state'i bildir
        presenter?.presentLoading()

        // 2. Worker'dan image yükleme iste
        downloadTask = worker?.loadImage(url: imageUrl) { [weak self] result in
            // ImageDownloadManager zaten main thread garantisi veriyor
            switch result {
            case .success(let image):
                self?.presenter?.presentImage(
                    response: .init(image: image, error: nil)
                )
            case .failure(let error):
                self?.presenter?.presentImage(
                    response: .init(image: nil, error: error)
                )
            }
        }
    }

    // MARK: - Cleanup
    deinit {
        downloadTask?.cancel()
        print("✅ PreviewInteractor deallocated")
    }
}
