//
//  SearchPageViewProtocol.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 28.09.2020.
//

import Foundation

protocol SearchPageViewProtocol: class {
    func prepareUI()
    func setTitle(title: String)
    func updateCollectionView(with snapshot: SearchPageSnapshot)
    func showError(errorDescription: String)
    func setLoading(isLoading: Bool)
    func share(trackUrl: String)
}
