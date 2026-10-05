//
//  PreviewRouter.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 4.10.2026.
//

import UIKit

// MARK: - Routing Logic Protocol
protocol PreviewRoutingLogic {
    func dismiss()
}

final class PreviewRouter: PreviewRoutingLogic {

    weak var viewController: UIViewController?

    // MARK: - Routing

    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}
