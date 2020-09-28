//
//  MainTabbar.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 26.09.2020.
//

import Foundation
import UIKit

class MainTabbar: UITabBarController {
    lazy var bar: PlayerBar = loadPlayerBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadHomeTab()
        loadSearchTab()
        handlePlayerStatus()
        view.addSubview(bar)
        bar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: bar.trailingAnchor).isActive = true
        bar.bottomAnchor.constraint(equalTo: tabBar.topAnchor).isActive = true
        bar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bar.isHidden = true
    }
    
    func handlePlayerStatus() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "PLAYER_STATUS"), object: nil, queue: .main) { (notification) in
            if let trackDetail = notification.object as? AlbumDetailTrackListData{
                self.bar.setData(title: trackDetail.title, image: UIImage(systemName: "music.quarternote.3")!)
            }
            if notification.userInfo?["hide"] as? Bool ?? false {
                DispatchQueue.main.async {
                    self.bar.isHidden = true
                }
            } else {
                DispatchQueue.main.async {
                    self.bar.updatePlayButton(to: (notification.userInfo?["isPlay"] as? Bool) ?? false)
                    self.bar.isHidden = false
                }
            }
        }
    }
    
    func loadPlayerBar() -> PlayerBar {
        let expandingView = UIView().loadNib(name: "PlayerBar") as? PlayerBar
        expandingView?.translatesAutoresizingMaskIntoConstraints = false
        expandingView?.delegate = self
        return expandingView ?? PlayerBar()
    }
}

extension MainTabbar: PlayerBarDelegate {
    func tapPlayPause() {
        MusicPlayer.player.togglePlayback()
    }
    
    func tapForward() {
        MusicPlayer.player.nextTrack()
    }
    
    func tapVolume() {
        
    }
}

extension MainTabbar {
    func loadHomeTab() {
        let navigationController = UINavigationController()
        let homeView = GenreListRouter.createModule(navigationController: navigationController)
        navigationController.viewControllers.append(homeView)
        navigationController.tabBarItem.image = UIImage(systemName: "house")
        navigationController.tabBarItem.title = "Home"
        self.addChild(navigationController)
    }
}

extension MainTabbar {
    func loadSearchTab() {
        let navigationController = UINavigationController()
        let searchView = SearchPageRouter.createModule(navigationController: navigationController)
        navigationController.viewControllers.append(searchView)
        navigationController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        navigationController.tabBarItem.title = "Search"
        self.addChild(navigationController)
    }
}
