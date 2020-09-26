//
//  GenreListViewProtocol.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 26.09.2020.
//

import Foundation

protocol GenreListViewProtocol: class {
    func prepareUI()
    func showGenreList(with snapshot: GenreListPageSnapshot)
    func showError()
    func setLoading(isLoading: Bool)
}
