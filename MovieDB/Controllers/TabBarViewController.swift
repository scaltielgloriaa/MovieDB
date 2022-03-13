//
//  ViewController.swift
//  MovieDB
//
//  Created by Scaltiel Gloria on 09/03/22.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        let tabBar1 = UINavigationController(rootViewController: HomeViewController())
        let tabBar2 = UINavigationController(rootViewController: FavoriteViewController())
        tabBar1.tabBarItem.image = UIImage(systemName: "house")
        tabBar2.tabBarItem.image = UIImage(systemName: "heart.fill")
        tabBar1.title = "Home"
        tabBar2.title = "Favorites"
        tabBar.tintColor = .label

        setViewControllers([tabBar1, tabBar2], animated: true)
    }
}
