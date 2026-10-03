//
//  PreviewViewController.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 3.10.2026.
//

import UIKit
import SnapKit

final class PreviewViewController: UIViewController {

    private let imageUrl: String
    private var downloadTask: Cancellable?

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 4
        scrollView.delegate = self
        return scrollView
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let activityIndicator = UIActivityIndicatorView(style: .large)

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .close)
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()

    init(imageUrl: String) {
        self.imageUrl = imageUrl
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        view.addSubview(activityIndicator)
        view.addSubview(closeButton)

        scrollView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.size.equalTo(scrollView.frameLayoutGuide)
        }
        activityIndicator.snp.makeConstraints { $0.center.equalToSuperview() }
        closeButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

        loadImage()
    }

    deinit { downloadTask?.cancel() }

    private func loadImage() {
        activityIndicator.startAnimating()
        downloadTask = ImageDownloadManager.shared.downloadImage(from: imageUrl) { [weak self] result in
            self?.activityIndicator.stopAnimating()
            if case .success(let image) = result { self?.imageView.image = image }
        }
    }

    @objc private func closeTapped() { dismiss(animated: true) }
}

extension PreviewViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? { imageView }
}
