//
//  PreviewInteractor.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 4.10.2026.
//

import UIKit

protocol PreviewBusinessLogic: AnyObject {
    func loadImage()
}

final class PreviewInteractor: PreviewBusinessLogic {
    // MARK: - Properties
    var presenter: PreviewPresentationLogic?
    var worker: PreviewWorkerLogic?
    
    private let imageUrl: String
    private var downloadTask: Cancellable?
    
    init(imageUrl: String) {
        self.imageUrl = imageUrl
    }
    
    func loadImage() {
        presenter?.presentLoading()
        
        downloadTask = worker?.loadImage(url: imageUrl) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let image):
                self.presenter?.presentImage(
                    response: .init(image: image, error: nil)
                )
            case .failure(let error):
                self.presenter?.presentImage(
                    response: .init(image: nil, error: error)
                )
            }
        }
    }
    
    deinit {
        downloadTask?.cancel()
    }
}
