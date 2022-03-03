//
//  SearchResultViewController.swift
//  NetflixClone
//
//  Created by Олег Федоров on 03.03.2022.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    private var titles: [Title] = []
    
    private let searchResultsCollectionView: UICollectionView = {
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
}

extension SearchResultViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        10
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
        
        cell.backgroundColor = .blue
        
        return cell
    }
}

extension SearchResultViewController: UICollectionViewDelegate {
    
}
