//
//  GenreListPresenterProtocol.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 26.09.2020.
//

import Foundation

protocol GenreListPresenterProtocol {
    func viewDidLoad()
    func selectGenre(at index: Int)
}

protocol GenreListInteractorOutput: class {
    func handleSearchResult(with result: Result<[GenreResponse], ApiError>)
}
