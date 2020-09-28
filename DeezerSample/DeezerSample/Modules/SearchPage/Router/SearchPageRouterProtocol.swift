//
//  SearchPageRouterProtocol.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 28.09.2020.
//

import Foundation

protocol SearchPageRouterProtocol {
    func navigateToArtistsDetail(to id: String)
    func navigateToAlbumdetail(to id: String, name: String)
}
