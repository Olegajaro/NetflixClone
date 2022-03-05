//
//  UpcomingViewController.swift
//  NetflixClone
//
//  Created by Олег Федоров on 01.03.2022.
//

import UIKit

class UpcomingViewController: UIViewController {

    private var titles: [Title] = []
    
    // MARK: - UIElements
    let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(
            TitleTableViewCell.self,
            forCellReuseIdentifier: TitleTableViewCell.identifier
        )
        return table
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        fetchUpcoming()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        upcomingTable.frame = view.bounds
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(upcomingTable)
        upcomingTable.dataSource = self
        upcomingTable.delegate = self
        upcomingTable.rowHeight = 140
    }
    
    // MARK: - Fetch data
    private func fetchUpcoming() {
        APICaller.shared.getUpcomingMovies { [weak self] titles in
            self?.titles = titles?.results ?? []
            self?.upcomingTable.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource
extension UpcomingViewController: UITableViewDataSource {
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
            titleName: (title.originalTitle ?? title.originalName) ?? "",
            posterURL: title.posterPath ?? ""
        ))
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension UpcomingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        guard
            let titleName = title.originalTitle ?? title.originalName
        else { return }
        
        APICaller.shared.getMovie(
            with: titleName + " trailer"
        ) { [weak self] searchResponse in
            let viewController = TitlePreviewController()
            
            guard
                let videoElement = searchResponse?.items.first,
                let overview = title.overview
            else { return }
            
            viewController.configure(with: TitlePreviewViewModel(
                title: titleName,
                youtubeVideo: videoElement,
                titleOverview: overview
            ))
            
            self?.navigationController?.pushViewController(viewController,
                                                     animated: true)
        }
    }
}
