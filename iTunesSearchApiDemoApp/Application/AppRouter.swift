//
//  AppRouter.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 4.10.2026.
//

import UIKit

final class AppRouter {

    private let window: UIWindow
    private let searchConfigurator: SearchConfigurator

    init(window: UIWindow,
         searchConfigurator: SearchConfigurator = SearchConfigurator()) {
        self.window = window
        self.searchConfigurator = searchConfigurator
    }

    func start() {
        window.rootViewController = searchConfigurator.configure()
        window.makeKeyAndVisible()
    }
}
