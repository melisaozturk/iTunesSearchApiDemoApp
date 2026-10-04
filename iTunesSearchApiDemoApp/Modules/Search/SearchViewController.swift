//
//  SearchViewController.swift
//  iTunesSearchApiDemoApp
//
//  Created by Melisa Öztürk on 2.10.2026.
//

import UIKit
import SnapKit

protocol SearchDisplayLogic: AnyObject {
    func displaySoftwares(viewModel: Search.FetchSoftwares.ViewModel)
    func displayLoading()
    func displayError(message: String)
}
 
final class SearchViewController: UIViewController {
 
    var interactor: SearchBusinessLogic?
    var router: SearchRoutingLogic?
 
    private var displayedSoftwares: [Search.FetchSoftwares.ViewModel.DisplayedSoftware] = []
    private let debouncer = Debouncer(delay: 0.5)
 
    private enum Constants {
        static let initialMessage = "Search for software to see screenshots"
        static let padding: CGFloat = 10
        static let numberOfColumns: CGFloat = 2
        static let labelsHeight: CGFloat = 60
    }
 
    // MARK: - UI Components
 
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for software..."
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        searchBar.showsCancelButton = true
        return searchBar
    }()
 
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = Constants.padding
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return layout
    }()
 
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        cv.backgroundColor = .systemBackground
        cv.delegate = self
        cv.dataSource = self
        cv.keyboardDismissMode = .onDrag
        cv.register(ScreenshotCell.self, forCellWithReuseIdentifier: ScreenshotCell.reuseIdentifier)
        return cv
    }()
 
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .systemBlue
        return indicator
    }()
 
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.initialMessage
        label.textAlignment = .center
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
 
    // MARK: - Lifecycle
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        interactor?.handleMemoryWarning()
    }
    
    deinit {
        debouncer.cancel()        
    }
    
    // MARK: - Private functions
    private func setupUI() {
        view.backgroundColor = .systemBackground
 
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        view.addSubview(emptyStateLabel)
 
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(56)
        }
 
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
 
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
 
        emptyStateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
        }
    }
 
    private func screenshotUrl(at indexPath: IndexPath) -> String? {
        guard displayedSoftwares.indices.contains(indexPath.section),
              let urls = displayedSoftwares[indexPath.section].screenshotUrls,
              urls.indices.contains(indexPath.item) else {
            return nil
        }
        return urls[indexPath.item]
    }
 
    private func updateList(with softwares: [Search.FetchSoftwares.ViewModel.DisplayedSoftware]) {
        displayedSoftwares = softwares
        collectionView.reloadData()
    }
 
    private func resetToInitialState() {
        debouncer.cancel()
        interactor?.cancelSearch()
        activityIndicator.stopAnimating()
        updateList(with: [])
        emptyStateLabel.text = Constants.initialMessage
        emptyStateLabel.isHidden = false
    }
}
 
// MARK: - SearchDisplayLogic
extension SearchViewController: SearchDisplayLogic {
    func displaySoftwares(viewModel: Search.FetchSoftwares.ViewModel) {
        activityIndicator.stopAnimating()
 
        if viewModel.isEmpty ?? false {
            updateList(with: [])
            emptyStateLabel.text = "No results found" //TODO: constant
            emptyStateLabel.isHidden = false
        } else {
            updateList(with: viewModel.softwares ?? [])
            emptyStateLabel.isHidden = true
        }
    }
 
    func displayLoading() {
        activityIndicator.startAnimating()
        emptyStateLabel.isHidden = true
    }
    
    func displayError(message: String) {
        activityIndicator.stopAnimating()
        updateList(with: [])
        emptyStateLabel.text = message
        emptyStateLabel.isHidden = false
    }
}
 
// MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        displayedSoftwares.count
    }
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        displayedSoftwares[section].screenshotUrls?.count ?? 0
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         guard let cell = collectionView.dequeueReusableCell(
             withReuseIdentifier: ScreenshotCell.reuseIdentifier,
             for: indexPath
         ) as? ScreenshotCell,
               let url = screenshotUrl(at: indexPath) else {
             return UICollectionViewCell()
         }

         // ImageProvider'ı inject et - VIP üzerinden
         cell.configure(
             with: displayedSoftwares[indexPath.section],
             screenshotUrl: url,
             imageProvider: { [weak self] urlString, completion in
                 // Interactor → Worker → ImageDownloadManager
                 return self?.interactor?.loadImage(url: urlString, completion: completion)
             }
         )
         return cell
     }
}
 
// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalPadding = Constants.padding * (Constants.numberOfColumns + 1)
        let itemWidth = floor((collectionView.bounds.width - totalPadding) / Constants.numberOfColumns)
        let itemHeight = itemWidth * 1.5 + Constants.labelsHeight
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
 
// MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let url = screenshotUrl(at: indexPath) else { return }
        router?.routeToImagePreview(screenshotUrl: url)
    }
}
 
// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let term = searchText.trimmingCharacters(in: .whitespaces)
 
        guard !term.isEmpty else {
            resetToInitialState()
            return
        }
 
        debouncer.debounce { [weak self] in
            self?.interactor?.fetchSoftwares(request: .init(searchTerm: term))
        }
    }
 
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
 
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        resetToInitialState()
    }
}
