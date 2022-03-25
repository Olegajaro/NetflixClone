//
//  CollectionViewTableViewCell.swift
//  NetflixClone
//
//  Created by Олег Федоров on 01.03.2022.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapped(
        _ cell: CollectionViewTableViewCell,
        viewModel: TitlePreviewViewModel
    )
}

class CollectionViewTableViewCell: UITableViewCell {

    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private var titles: [Title] = []
    
    // MARK: - UIElements
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            TitleCollectionViewCell.self,
            forCellWithReuseIdentifier: TitleCollectionViewCell.identifier
        )
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Subview Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = contentView.bounds
    }
    
    // MARK: - Configure
    public func configure(with titles: [Title]) {
        self.titles = titles
        collectionView.reloadData()
    }
    
    // MARK: - Save title to download section
    private func downloadTitleAt(indexPath: IndexPath) {
        DatabaseService.shared.downloadTitleWith(
            model: titles[indexPath.item]
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
extension CollectionViewTableViewCell: UICollectionViewDataSource {
    
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
        else { return UICollectionViewCell()}
        
        let posterPath = titles[indexPath.row].posterPath ?? ""
        
        cell.configure(with: posterPath)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CollectionViewTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        guard
            let titleName = title.originalTitle ?? title.originalName,
            let titleOverview = title.overview
        else { return }
        
        APICaller.shared.getMovie(with: titleName + " trailer") { searchResponse in
            
            guard let videoElement = searchResponse?.items.first else { return }
            
            let viewModel = TitlePreviewViewModel(
                title: titleName,
                youtubeVideo: videoElement,
                titleOverview: titleOverview
            )
            
            self.delegate?.collectionViewTableViewCellDidTapped(
                self,
                viewModel: viewModel
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

