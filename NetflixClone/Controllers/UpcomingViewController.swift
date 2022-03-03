//
//  UpcomingViewController.swift
//  NetflixClone
//
//  Created by Олег Федоров on 01.03.2022.
//

import UIKit

class UpcomingViewController: UIViewController {

    private var titles: [Title] = []
    
    let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(
            UpcomingTableViewCell.self,
            forCellReuseIdentifier: UpcomingTableViewCell.identifier
        )
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(upcomingTable)
        upcomingTable.dataSource = self
        upcomingTable.delegate = self
        upcomingTable.rowHeight = 140
        
        fetchUpcoming()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        upcomingTable.frame = view.bounds
    }
    
    private func fetchUpcoming() {
        APICaller.shared.getUpcomingMovies { [weak self] titles in
            self?.titles = titles?.results ?? []
            self?.upcomingTable.reloadData()
        }
    }
}

extension UpcomingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: UpcomingTableViewCell.identifier, for: indexPath
            ) as? UpcomingTableViewCell
        else { return UITableViewCell() }
        
        let title = titles[indexPath.row]
        
        cell.configure(with: UpcomingViewModel(
            titleName: (title.originalTitle ?? title.originalName) ?? "",
            posterURL: title.posterPath ?? ""
        ))
        
        return cell
    }
}

extension UpcomingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
