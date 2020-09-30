//
//  ArtistDetailPagePresenterProtocol.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 27.09.2020.
//

import Foundation

protocol ArtistDetailPagePresenterProtocol {
    func viewDidLoad()
    func changeIndex(to index: Int)
    func selectItem(at index: Int)
}

protocol ArtistDetailInteractorOutput: class {
    func handleDetailResult(with result: Result<ArtistResponse, ApiError>)
    func handleAlbumsResult(with result: Result<[AlbumResponse], ApiError>)
    func handleRelatedResult(with result: Result<[ArtistResponse], ApiError>)
}
