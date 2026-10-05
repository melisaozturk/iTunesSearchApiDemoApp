//
//  PreviewModel.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 4.10.2026.
//

import UIKit

enum Preview {
    enum LoadImage {

        struct Response {
            let image: UIImage?
            let error: NetworkError?
        }

        struct ViewModel {
            let image: UIImage?
            let errorMessage: String?
        }
    }
}
