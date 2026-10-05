//
//  PreviewPresenter.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 4.10.2026.
//

protocol PreviewPresentationLogic: AnyObject {
    func presentImage(response: Preview.LoadImage.Response)
    func presentLoading()
}

final class PreviewPresenter: PreviewPresentationLogic {

    weak var viewController: PreviewDisplayLogic?

    func presentImage(response: Preview.LoadImage.Response) {
        if let error = response.error {
            let errorMessage = formatErrorMessage(error)
            let viewModel = Preview.LoadImage.ViewModel(
                image: nil,
                errorMessage: errorMessage
            )
            viewController?.displayImage(viewModel: viewModel)
            return
        }
        
        let viewModel = Preview.LoadImage.ViewModel(
            image: response.image,
            errorMessage: nil
        )
        viewController?.displayImage(viewModel: viewModel)
    }

    func presentLoading() {
        viewController?.displayLoading()
    }

    private func formatErrorMessage(_ error: NetworkError) -> String {
        return error.userMessage
    }
}
