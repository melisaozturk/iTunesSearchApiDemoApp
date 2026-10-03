//
//  SearchViewController.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 2.10.2026.
//

import UIKit

final class SearchViewController: UIViewController {

    private let worker = SearchWorker()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        testSearch()
    }

    private func testSearch() {
        worker.searchApps(term: "facebook") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let apps):
                    
                    if let firstApp = apps.first {

                        firstApp.screenshotUrls!.prefix(3).forEach { url in
                            
                        }
                    }

                case .failure(let error):
                    //TODO: Log-
                    #if Debug
                        print("❌ Error: \(error.localizedDescription)")
                    #endif
                }
            }
        }
    }
}
