//
//  PreviewConfigurator.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 4.10.2026.
//

import UIKit

final class PreviewConfigurator {

    static func configure(imageUrl: String) -> PreviewViewController {
        // 1. Create VIP components
        let viewController = PreviewViewController()
        let interactor = PreviewInteractor(imageUrl: imageUrl)
        let presenter = PreviewPresenter()
        let router = PreviewRouter()
        let worker = PreviewWorker()

        // 2. Wire up connections

        // ViewController → Interactor, Router
        viewController.interactor = interactor
        viewController.router = router

        // Interactor → Presenter, Worker
        interactor.presenter = presenter
        interactor.worker = worker

        // Presenter → ViewController (weak)
        presenter.viewController = viewController

        // Router → ViewController (weak)
        router.viewController = viewController

        return viewController
    }
}
