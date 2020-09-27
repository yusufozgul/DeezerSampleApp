//
//  ArtistListPageVCProtocol.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 27.09.2020.
//

import Foundation

protocol ArtistListPageVCProtocol: class {
    func prepareUI()
    func showArtistList(with snapshot: ArtistListPageSnapshot)
    func showError(errorDescription: String)
    func setLoading(isLoading: Bool)
}
