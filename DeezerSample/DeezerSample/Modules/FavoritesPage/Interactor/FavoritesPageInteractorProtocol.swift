//
//  FavoritesPageInteractorProtocol.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 30.09.2020.
//

import Foundation

protocol FavoritesPageInteractorProtocol {
    func getFavorites()
    func deleteFavorite(at id: Int)
}
