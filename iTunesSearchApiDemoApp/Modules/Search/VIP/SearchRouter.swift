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

    // MARK: - Routing

    func routeToImagePreview(screenshotUrl: String) {
        // PreviewConfigurator kullan (VIP uyumlu)
        let preview = PreviewConfigurator.configure(imageUrl: screenshotUrl)
        viewController?.present(preview, animated: true)
    }
}
