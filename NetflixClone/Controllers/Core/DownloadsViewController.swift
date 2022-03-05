//
//  DownloadsViewController.swift
//  NetflixClone
//
//  Created by Олег Федоров on 01.03.2022.
//

import UIKit

class DownloadsViewController: UIViewController {

    private var titles: [TitleItem] = [TitleItem]()
    
    // MARK: - UIElements
    private let downloadedTable: UITableView = {
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
        fetchLocalStorageForDownload()
        createObserver()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        downloadedTable.frame = view.bounds
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        downloadedTable.dataSource = self
        downloadedTable.delegate = self
        downloadedTable.rowHeight = 140
        
        view.addSubview(downloadedTable)
    }

    // MARK: - Private Methods
    private func fetchLocalStorageForDownload() {
        DatabaseService.shared.fetchTitlesFromDatabase { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                self?.downloadedTable.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func createObserver() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("downloaded"),
            object: nil,
            queue: nil
        ) { _ in
            self.fetchLocalStorageForDownload()
        }
    }
}

// MARK: - UITableViewDataSource
extension DownloadsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TitleTableViewCell.identifier,
                for: indexPath
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
extension DownloadsViewController: UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .delete :
            DatabaseService.shared.deleteTitleWith(
                model: titles[indexPath.row]
            ) { [weak self] result in
                switch result {
                case .success():
                    self?.titles.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    print("DEBUG: deleted from the database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            break
        }
    }
}
