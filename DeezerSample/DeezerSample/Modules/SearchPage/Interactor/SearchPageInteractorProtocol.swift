//
//  SearchPageInteractorProtocol.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 28.09.2020.
//

import Foundation

protocol SearchPageInteractorProtocol {
    func searchAlbum(at key: String)
    func searchArtist(at key: String)
    func searchTrack(at key: String)
}
