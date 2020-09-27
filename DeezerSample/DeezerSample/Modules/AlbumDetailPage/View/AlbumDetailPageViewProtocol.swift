//
//  AlbumDetailPageViewProtocol.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 27.09.2020.
//

import Foundation

protocol AlbumDetailPageViewProtocol: class {
    func prepareUI()
    func setTitle(title: String)
    func showTrackList(with snapshot: AlbumDetailPageSnapshot)
    func showError(errorDescription: String)
    func setLoading(isLoading: Bool)
}
