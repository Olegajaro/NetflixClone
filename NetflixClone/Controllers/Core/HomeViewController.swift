//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Олег Федоров on 01.03.2022.
//

import UIKit

enum Sections: Int {
    case trendingMovies = 0
    case tredingTV = 1
    case popular = 2
    case upcomingMovies = 3
    case topRated = 4
}

class HomeViewController: UIViewController {
    
    let sectionTitles: [String] = [
        "Trending Movies", "Trending TV", "Popular",
        "Upcoming Movies", "Top Rated"
    ]
    
    // MARK: - UIElements
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(
            CollectionViewTableViewCell.self,
            forCellReuseIdentifier: CollectionViewTableViewCell.identifier
        )
        return table
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupViews()
     }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        let headerView = HeroHeaderView(frame: CGRect(
            x: 0, y: 0,
            width: view.bounds.width,
            height: 450
        ))
        homeFeedTable.tableHeaderView = headerView
    }
    
    private func setupNavBar() {
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: image,
            style: .done,
            target: self,
            action: nil
        )
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage(systemName: "person"),
                style: .done,
                target: self,
                action: nil
            ),
            UIBarButtonItem(
                image: UIImage(systemName: "play.rectangle"),
                style: .done,
                target: self,
                action: nil
            )
        ]
        
        navigationController?.navigationBar.tintColor = .systemRed
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(
            translationX: 0,
            y: min(0, -offset)
        )
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CollectionViewTableViewCell.identifier,
                for: indexPath
            ) as? CollectionViewTableViewCell
        else { return UITableViewCell()}
        
        switch indexPath.section {
        case Sections.trendingMovies.rawValue:
            
            APICaller.shared.getTrendingMovies { titles in
                cell.configure(with: titles?.results ?? [])
            }
            
        case Sections.tredingTV.rawValue:
            
            APICaller.shared.getTrendingTvs { titles in
                cell.configure(with: titles?.results ?? [])
            }
            
        case Sections.popular.rawValue:
            
            APICaller.shared.getPopularMovies { titles in
                cell.configure(with: titles?.results ?? [])
            }
            
        case Sections.upcomingMovies.rawValue:
            
            APICaller.shared.getUpcomingMovies { titles in
                cell.configure(with: titles?.results ?? [])
            }
            
        case Sections.topRated.rawValue:
            
            APICaller.shared.getTopRatedMovies { titles in
                cell.configure(with: titles?.results ?? [])
            }
            
        default:
            return UITableViewCell()
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplayHeaderView view: UIView,
                   forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(
            x: header.bounds.origin.x + 20,
            y: header.bounds.origin.y,
            width: 100,
            height: header.bounds.height
        )
        header.textLabel?.textColor = .label
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
}


