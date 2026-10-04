//
//  ScreenshotCell.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 3.10.2026.
//

import UIKit
import SnapKit

final class ScreenshotCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ScreenshotCell"
    
    private var currentDownloadTask: Cancellable?
    private var representedUrl: String?
    
    // MARK: - UI Components
        private let screenshotImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray6
        iv.layer.cornerRadius = 8
        return iv
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented") //TODO: fix
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        currentDownloadTask?.cancel()
        currentDownloadTask = nil
        representedUrl = nil
        
        screenshotImageView.image = nil
        screenshotImageView.backgroundColor = .systemGray6
        appNameLabel.text = nil
        artistNameLabel.text = nil
        activityIndicator.stopAnimating()
    }
    
    private func setupUI() {
        contentView.addSubview(screenshotImageView)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(appNameLabel)
        contentView.addSubview(artistNameLabel)
        
        screenshotImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(screenshotImageView.snp.width).multipliedBy(1.5) // 2:3
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(screenshotImageView)
        }
        
        appNameLabel.snp.makeConstraints { make in
            make.top.equalTo(screenshotImageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(4)
        }
        
        artistNameLabel.snp.makeConstraints { make in
            make.top.equalTo(appNameLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(4)
            make.bottom.lessThanOrEqualToSuperview().inset(8)
        }
    }
    
    func configure(with app: Search.FetchSoftwares.ViewModel.DisplayedSoftware,
                   screenshotUrl: String,
                   imageProvider: @escaping (String, @escaping (Result<UIImage, NetworkError>) -> Void) -> Cancellable?) {
        appNameLabel.text = app.name
        artistNameLabel.text = app.artistName

        currentDownloadTask?.cancel()
        representedUrl = screenshotUrl

        screenshotImageView.image = nil
        screenshotImageView.backgroundColor = .systemGray6
        activityIndicator.startAnimating()

        // ImageDownloadManager.shared YERİNE inject edilen imageProvider kullan
        currentDownloadTask = imageProvider(screenshotUrl) { [weak self] result in
            guard let self, self.representedUrl == screenshotUrl else { return }

            self.activityIndicator.stopAnimating()

            switch result {
            case .success(let image):
                self.screenshotImageView.image = image
                self.screenshotImageView.backgroundColor = .clear
            case .failure:
                self.screenshotImageView.backgroundColor = .systemRed.withAlphaComponent(0.2)
            }
        }
    }
}

