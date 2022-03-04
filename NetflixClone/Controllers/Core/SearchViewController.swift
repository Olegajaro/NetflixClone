//
//  SearchViewController.swift
//  NetflixClone
//
//  Created by Олег Федоров on 01.03.2022.
//

import UIKit

class SearchViewController: UIViewController {

    private var titles: [Title] = []
    
    private let discoverTable: UITableView = {
        let table = UITableView()
        table.register(
            TitleTableViewCell.self,
            forCellReuseIdentifier: TitleTableViewCell.identifier
        )
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(
            searchResultsController: SearchResultViewController()
        )
        controller.searchBar.placeholder = "Search for a Movie or a TV show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        fetchDiscoverMovies()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        discoverTable.frame = view.bounds
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = "Search"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .label
        
        discoverTable.dataSource = self
        discoverTable.delegate = self
        discoverTable.rowHeight = 140
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        
        view.addSubview(discoverTable)
    }
    
    private func fetchDiscoverMovies() {
        APICaller.shared.getDiscoverMovies { [weak self] titles in
            guard let titles = titles?.results else { return }
            
            self?.titles = titles
            self?.discoverTable.reloadData()
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TitleTableViewCell.identifier, for: indexPath
            ) as? TitleTableViewCell
        else { return UITableViewCell() }
        
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(
            titleName: (title.originalName ?? title.originalTitle) ?? "",
            posterURL: title.posterPath ?? ""
        ))
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        
        guard
            let query = searchBar.text,
            !query.trimmingCharacters(in: .whitespaces).isEmpty,
            query.trimmingCharacters(in: .whitespaces).count >= 3,
            let resultsController = searchController.searchResultsController as? SearchResultViewController
        else { return }
        
        APICaller.shared.search(with: query) { titles in
            guard let titles = titles?.results else { return }
            
            resultsController.titles = titles
            resultsController.searchResultsCollectionView.reloadData()
        }
    }
}
