//
//  PreviewViewController.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 3.10.2026.
//

import UIKit
import SnapKit

protocol PreviewDisplayLogic: AnyObject {
    func displayImage(viewModel: Preview.LoadImage.ViewModel)
    func displayLoading()
    func displayError(message: String)
}

final class PreviewViewController: UIViewController {
    
    // MARK: - Properties
    var interactor: PreviewBusinessLogic?
    var router: PreviewRoutingLogic?
    
    // MARK: - UI Components
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        return imageView
    }()
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .close)
        button.tintColor = .white
        button.backgroundColor = .white.withAlphaComponent(0.6)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        interactor?.loadImage()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(imageView)
        view.addSubview(activityIndicator)
        view.addSubview(errorLabel)
        view.addSubview(closeButton)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        errorLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.size.equalTo(50)
        }
    }
    
    // MARK: - Actions
    @objc private func closeTapped() {
        router?.dismiss()
    }
}

// MARK: - PreviewDisplayLogic
extension PreviewViewController: PreviewDisplayLogic {
    
    func displayImage(viewModel: Preview.LoadImage.ViewModel) {
        activityIndicator.stopAnimating()
        
        if let image = viewModel.image {
            imageView.image = image
            errorLabel.isHidden = true
        } else if let errorMessage = viewModel.errorMessage {
            displayError(message: errorMessage)
        }
    }
    
    func displayLoading() {
        activityIndicator.startAnimating()
        imageView.image = nil
        errorLabel.isHidden = true
    }
    
    func displayError(message: String) {
        activityIndicator.stopAnimating()
        errorLabel.text = message
        errorLabel.isHidden = false
    }
}
