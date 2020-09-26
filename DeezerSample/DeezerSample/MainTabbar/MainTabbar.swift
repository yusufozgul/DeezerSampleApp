//
//  MainTabbar.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 26.09.2020.
//

import Foundation
import UIKit

class MainTabbar: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHomeTab()
    }
}

extension MainTabbar {
    func loadHomeTab() {
        let navigationController = UINavigationController()
        let homeView = GenreListRouter.createModule(navigationController: navigationController)
        navigationController.viewControllers = [homeView]
        navigationController.tabBarItem.image = UIImage(systemName: "house")
        navigationController.tabBarItem.title = "Home"
        self.addChild(navigationController)
    }
}
