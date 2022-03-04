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
    
    public func configure(with titles: [Title]) {
        self.titles = titles
        collectionView.reloadData()
    }
}

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
}

