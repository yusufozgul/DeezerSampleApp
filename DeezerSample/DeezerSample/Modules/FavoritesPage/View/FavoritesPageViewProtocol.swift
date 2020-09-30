//
//  FavoritesPageViewProtocol.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 30.09.2020.
//

import Foundation

protocol FavoritesPageViewProtocol: class {
    func prepareUI()
    func showTrackList(with snapshot: FavoritesPageSnapshot)
    func showError(errorDescription: String)
    func setLoading(isLoading: Bool)
    func share(trackUrl: String)
}
