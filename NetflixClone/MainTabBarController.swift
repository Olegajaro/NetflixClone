//
//  ViewController.swift
//  NetflixClone
//
//  Created by Олег Федоров on 01.03.2022.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupTabBar()
    }
    
    private func setupTabBar() {
        
        let homeNC = UINavigationController(rootViewController: HomeViewController())
        let upcomingNC = UINavigationController(rootViewController: UpcomingViewController())
        let searchNC = UINavigationController(rootViewController: SearchViewController())
        let downloadsNC = UINavigationController(rootViewController: DownloadsViewController())
        
        homeNC.tabBarItem.image = UIImage(systemName: "house")
        upcomingNC.tabBarItem.image = UIImage(systemName: "play.circle")
        searchNC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        downloadsNC.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        
        homeNC.title = "Home"
        upcomingNC.title = "Coming Soon"
        searchNC.title = " Top Search"
        downloadsNC.title = "Downloads"
        
        tabBar.tintColor = .label
        
        let viewControllers = [homeNC, upcomingNC, searchNC, downloadsNC]
        
        setViewControllers(viewControllers, animated: true)
    }
}

