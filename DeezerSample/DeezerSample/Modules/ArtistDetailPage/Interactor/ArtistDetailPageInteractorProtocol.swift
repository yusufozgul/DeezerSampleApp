//
//  ArtistDetailPageInteractorProtocol.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 27.09.2020.
//

import Foundation

protocol ArtistDetailPageInteractorProtocol {
    func getArtistDetail(at id: String)
    func getArtistAlbums(at id: String)
    func getArtistRelated(at id: String)
}
