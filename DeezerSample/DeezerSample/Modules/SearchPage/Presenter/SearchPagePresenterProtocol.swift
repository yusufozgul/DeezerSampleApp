//
//  SearchPagePresenterProtocol.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 28.09.2020.
//

import Foundation

protocol SearchPagePresenterProtocol {
    func viewDidLoad()
    func search(with key: String)
    func selectItem(at indexPath: IndexPath)
}

protocol SearchPageInteractorOutput: class {
    func handleAlbumSearchResult(with result: Result<[SearchAlbumResponse], ApiError>)
    func handleArtistSearchResult(with result: Result<[SearchArtistResponse], ApiError>)
    func handleTrackSearchResult(with result: Result<[SearchTrackResponse], ApiError>)
}
