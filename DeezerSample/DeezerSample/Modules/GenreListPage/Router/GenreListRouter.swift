//
//  GenreListRouter.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 26.09.2020.
//

import Foundation
import UIKit

class GenreListRouter {
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    static func createModule(navigationController: UINavigationController) -> GenreListPage {
        let view = GenreListPage()
        let interactor = GenreListInteractor()
        let router = GenreListRouter(navigationController: navigationController)
        let presenter = GenreListPresenter(view: view,
                                           interactor: interactor,
                                           router: router)
        interactor.output = presenter
        view.presenter = presenter
        return view
    }
}

extension GenreListRouter: GenreListRouterProtocol {
    func navigateToGenresArtist(to id: String) {
        print("Navigating to \(id)")
    }
}
