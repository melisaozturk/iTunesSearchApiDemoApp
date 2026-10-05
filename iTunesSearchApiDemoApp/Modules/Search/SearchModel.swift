//
//  SearchModel.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 3.10.2026.
//

enum Search {
    enum FetchSoftwares {
        
        struct Request {
            let searchTerm: String?
        }

        struct Response {
            let softwares: [SoftwareResult]
            let error: APIError?
        }

        struct ViewModel {
            struct DisplayedSoftware {
                let name: String
                let artistName: String
                let screenshotUrls: [String]
            }

            let softwares: [DisplayedSoftware]
        }
    }
}
