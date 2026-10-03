//
//  SearchRouter.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 2.10.2026.
//

import UIKit

protocol SearchRouterDelegate: AnyObject {
    func routeToImagePreview(screenshotUrl: String)
}
 
final class SearchRouter: SearchRouterDelegate {
 
    weak var viewController: UIViewController?
 
    // MARK: - Routing
 
    func routeToImagePreview(screenshotUrl: String) {
        let preview = PreviewViewController(imageUrl: screenshotUrl)
        viewController?.present(preview, animated: true)
    }
}
 
