//
//  ArtistListPagePresenterProtocol.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 27.09.2020.
//

import Foundation

protocol ArtistListPagePresenterProtocol {
    func viewDidLoad()
    func selectArtist(at index: Int)
}

protocol ArtistListInteractorOutput: class {
    func handleSearchResult(with result: Result<[ArtistResponse], ApiError>)
}
