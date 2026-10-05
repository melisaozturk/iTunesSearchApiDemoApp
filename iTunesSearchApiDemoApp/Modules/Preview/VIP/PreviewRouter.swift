//
//  PreviewRouter.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 4.10.2026.
//

import UIKit

protocol PreviewRoutingLogic: AnyObject {
    func dismiss()
}

final class PreviewRouter: PreviewRoutingLogic {

    weak var viewController: UIViewController?

    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}
