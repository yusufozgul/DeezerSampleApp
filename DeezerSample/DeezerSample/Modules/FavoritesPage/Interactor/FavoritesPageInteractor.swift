//
//  FavoritesPageInteractor.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 30.09.2020.
//

import Foundation

class FavoritesPageInteractor: FavoritesPageInteractorProtocol {
    weak var output: FavoritesInteractorOutput?
    
    func getFavorites() {
        let favorites = DataBaseController.shared.fetch()
        output?.handleTrackResult(with: .success(favorites))
    }
    
    func deleteFavorite(at id: Int) {
        DataBaseController.shared.deleteTrack(at: id)
    }
}
