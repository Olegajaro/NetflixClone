//
//  SearchResultViewController.swift
//  NetflixClone
//
//  Created by Олег Федоров on 03.03.2022.
//

import UIKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func searchResultViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel)
}

class SearchResultViewController: UIViewController {
    
    weak var delegate: SearchResultViewControllerDelegate?
    
    public var titles: [Title] = []
    
    // MARK: - UIElements
    public let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(
            width: UIScreen.main.bounds.width / 3 - 6,
            height: 200
        )
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            TitleCollectionViewCell.self,
            forCellWithReuseIdentifier: TitleCollectionViewCell.identifier
        )
        return collectionView
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        searchResultsCollectionView.dataSource = self
        searchResultsCollectionView.delegate = self
        
        view.addSubview(searchResultsCollectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchResultsCollectionView.frame = view.bounds
    }
    
    // MARK: - Save title to download section
    private func downloadTitleAt(indexPath: IndexPath) {
        DatabaseService.shared.downloadTitleWith(
            model: titles[indexPath.row]
        ) { result in
            switch result {
            case .success():
                NotificationCenter.default.post(
                    name: NSNotification.Name("downloaded"),
                    object: nil
                )
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension SearchResultViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        titles.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TitleCollectionViewCell.identifier,
                for: indexPath
            ) as? TitleCollectionViewCell
        else { return UICollectionViewCell() }
        
        let title = titles[indexPath.row]
        cell.configure(with: title.posterPath ?? "")
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SearchResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.item]
        
        guard
            let titleName = title.originalTitle ?? title.originalName,
            let overview = title.overview
        else { return }
        
        APICaller.shared.getMovie(
            with: titleName + " trailer"
        ) { [weak self] searchResponse in
            
            guard let videoElement = searchResponse?.items.first else { return }
            
            self?.delegate?.searchResultViewControllerDidTapItem(
                TitlePreviewViewModel(
                title: titleName,
                youtubeVideo: videoElement,
                titleOverview: overview
                )
            )
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfigurationForItemAt indexPath: IndexPath,
                        point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil
        ) { _ in
            let downloadAction = UIAction(
                title: "Download",
                state: .off) { [weak self] _ in
                    self?.downloadTitleAt(indexPath: indexPath)
                }
            
            return UIMenu(
                title: "",
                options: .displayInline,
                children: [downloadAction]
            )
        }
        
        return config
    }
}
