//
//  SearchPageRouter.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 28.09.2020.
//

import Foundation
import UIKit

class SearchPageRouter {
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    static func createModule(navigationController: UINavigationController?) -> SearchPageVC {
        let view = SearchPageVC()
        let interactor = SearchPageInteractor()
        let router = SearchPageRouter(navigationController: navigationController)
        let presenter = SearchPagePresenter(view: view,
                                           interactor: interactor,
                                           router: router)
        interactor.output = presenter
        view.presenter = presenter
        return view
    }

}

extension SearchPageRouter: SearchPageRouterProtocol {
    func navigateToArtistsDetail(to id: String) {
        let artistDetailPage = ArtistDetailRouter.createModule(navigationController: navigationController, artistID: id)
        self.navigationController?.pushViewController(artistDetailPage, animated: true)
    }
    
    func navigateToAlbumdetail(to id: String, name: String) {
        let albumPage = AlbumDetailRouter.createModule(navigationController: navigationController, albumID: id, albumName: name)
        self.navigationController?.pushViewController(albumPage, animated: true)
    }
}
