//
//  FavoritesPresenterProtocol.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 30.09.2020.
//

import Foundation

protocol FavoritesPresenterProtocol {
    func viewDidLoad()
    func selectTrack(at index: Int)
    func favoriteTrack(at index: Int)
    func shareTrack(at index: Int)
    func reloadList()
}

protocol FavoritesInteractorOutput: class {
    func handleTrackResult(with result: Result<[AlbumDetailTrackListData], ApiError>)
}
