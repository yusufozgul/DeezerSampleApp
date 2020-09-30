//
//  AlbumDetailPresenterProtocol.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 27.09.2020.
//

import Foundation

protocol AlbumDetailPresenterProtocol {
    func viewDidLoad()
    func selectTrack(at index: Int)
    func favoriteTrack(at index: Int)
    func shareTrack(at index: Int)
}

protocol AlbumDetailInteractorOutput: class {
    func handleAlbumDetail(with result: Result<AlbumDetailResponse, ApiError>)
}
