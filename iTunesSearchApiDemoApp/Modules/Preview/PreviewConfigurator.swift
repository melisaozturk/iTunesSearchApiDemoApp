//
//  PreviewConfigurator.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 4.10.2026.
//

import UIKit

final class PreviewConfigurator: AnyObject {

    private let imageDownloadManager: ImageDownloadManager

    init(imageDownloadManager: ImageDownloadManager = .shared) {
        self.imageDownloadManager = imageDownloadManager
    }

    func configure(imageUrl: String) -> PreviewViewController {
        let viewController = PreviewViewController()
        let interactor = PreviewInteractor(imageUrl: imageUrl)
        let presenter = PreviewPresenter()
        let router = PreviewRouter()
        let worker = PreviewWorker(imageDownloadManager: imageDownloadManager)

        viewController.interactor = interactor
        viewController.router = router

        interactor.presenter = presenter
        interactor.worker = worker

        presenter.viewController = viewController
        router.viewController = viewController

        return viewController
    }
}
