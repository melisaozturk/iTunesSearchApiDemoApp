//
//  PreviewModel.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 4.10.2026.
//


import UIKit

enum Preview {

    // MARK: - Load Image Use Case
    enum LoadImage {

        struct Request {
            let imageUrl: String
        }

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
