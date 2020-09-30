//
//  ArtistDetailPageViewProtocol.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 27.09.2020.
//

import Foundation

protocol ArtistDetailPageViewProtocol: class {
    func prepareUI()
    func setTitle(title: String)
    func updateCollectionView(with snapshot: ArtistDetailPageSnapshot)
    func showError(errorDescription: String)
    func setLoading(isLoading: Bool)
}
