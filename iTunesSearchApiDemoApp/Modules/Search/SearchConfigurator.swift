//
//  SearchConfigurator.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 4.10.2026.
//

import UIKit

final class SearchConfigurator: AnyObject {
    
    private let apiClient: APIClient
    private let previewConfigurator: PreviewConfigurator
    
    init(apiClient: APIClient = URLSessionAPIClient(),
         previewConfigurator: PreviewConfigurator = PreviewConfigurator()) {
        self.apiClient = apiClient
        self.previewConfigurator = previewConfigurator
    }
    
    func configure() -> SearchViewController {
        let viewController = SearchViewController()
        let interactor = SearchInteractor()
        let presenter = SearchPresenter()
        let router = SearchRouter(previewConfigurator: previewConfigurator)
        
        viewController.interactor = interactor
        viewController.router = router
        
        interactor.presenter = presenter
        interactor.worker = SearchWorker(apiClient: apiClient)
        
        presenter.viewController = viewController
        router.viewController = viewController
        
        return viewController
    }
}
