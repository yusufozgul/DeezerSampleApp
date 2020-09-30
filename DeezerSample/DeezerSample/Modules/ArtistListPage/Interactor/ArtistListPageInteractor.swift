//
//  ArtistListPageInteractor.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 27.09.2020.
//

import Foundation

class ArtistListPageInteractor {
    weak var output: ArtistListInteractorOutput?
}

extension ArtistListPageInteractor: ArtistListPageInteractorProtocol {
    func getArtists(at id: String) {
        let service = ApiService<ApiResponseWithInData<[ArtistResponse]>>()
        let request = ArtistListRequest(id: id)
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
