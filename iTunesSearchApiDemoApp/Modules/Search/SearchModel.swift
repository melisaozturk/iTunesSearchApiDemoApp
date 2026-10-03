//
//  SearchModel.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 3.10.2026.
//

enum Search {

    // MARK: - Fetch Software Use Case
    enum FetchSoftwares {

        struct Request {
            let searchTerm: String?
        }

        struct Response {
            let softwares: [SoftwareResult]?
            let error: APIError?
        }

        struct ViewModel {
            struct DisplayedSoftware {
                let trackId: Int
                let name: String?
                let artistName: String?
                let iconUrl: String?
                let screenshotUrls: [String]?
            }

            let softwares: [DisplayedSoftware]?
            let isEmpty: Bool?
            let errorMessage: String?
        }
    }
}
