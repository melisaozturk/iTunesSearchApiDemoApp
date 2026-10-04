//
//  SearchConfigurator.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 4.10.2026.
//

import UIKit

final class SearchConfigurator {
    static func configure() -> SearchViewController {
        let viewController = SearchViewController()
        let interactor = SearchInteractor()
        let presenter = SearchPresenter()
        let router = SearchRouter()

        viewController.interactor = interactor
        viewController.router = router

        interactor.presenter = presenter
        interactor.worker = SearchWorker()

        presenter.viewController = viewController
        router.viewController = viewController

        return viewController
    }
}
