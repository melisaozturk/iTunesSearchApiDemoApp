//
//  SearchRouter.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 2.10.2026.
//

import UIKit

protocol SearchRoutingLogic: AnyObject {
    func routeToImagePreview(screenshotUrl: String)
}

final class SearchRouter: SearchRoutingLogic {

    weak var viewController: UIViewController?
    private let previewConfigurator: PreviewConfigurator

    init(previewConfigurator: PreviewConfigurator = PreviewConfigurator()) {
        self.previewConfigurator = previewConfigurator
    }

    func routeToImagePreview(screenshotUrl: String) {
        let preview = previewConfigurator.configure(imageUrl: screenshotUrl)
        viewController?.present(preview, animated: true)
    }
}
