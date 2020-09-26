//
//  GenreListInteractor.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 26.09.2020.
//

import Foundation

class GenreListInteractor {
    weak var output: GenreListInteractorOutput?
}

extension GenreListInteractor: GenreListInteractorProtocol {
    func getGenres() {
        let service = ApiService<ApiResponseWithInData<[GenreResponse]>>()
        let request = GenreListRequest()
        
        service.getData(request: request) { (result) in
            switch result {
            case .success(let data):
                self.output?.handleSearchResult(with: .success(data.data))
            case .failure(let error):
                self.output?.handleSearchResult(with: .failure(error))
            }
        }
    }
}
