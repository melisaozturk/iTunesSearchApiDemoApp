//
//  AppRouter.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 4.10.2026.
//

import UIKit

final class AppRouter {
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        window.rootViewController = SearchConfigurator.configure()
        window.makeKeyAndVisible()
    }
}
