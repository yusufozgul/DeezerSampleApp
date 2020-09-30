//
//  SearchPageInteractor.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 28.09.2020.
//

import Foundation

class SearchPageInteractor {
    weak var output: SearchPageInteractorOutput?
}

extension SearchPageInteractor: SearchPageInteractorProtocol {
    func searchAlbum(at key: String) {
        let service = ApiService<ApiResponseWithInData<[SearchAlbumResponse]>>()
        let request = AlbumSearchRequest(key: key)
        service.getData(request: request) { (result) in
            switch result {
            case .success(let data):
                self.output?.handleAlbumSearchResult(with: .success(data.data))
            case .failure(let error):
                self.output?.handleAlbumSearchResult(with: .failure(error))
            }
        }
    }
    
    func searchArtist(at key: String) {
        let service = ApiService<ApiResponseWithInData<[SearchArtistResponse]>>()
        let request = ArtistSearchRequest(key: key)
        service.getData(request: request) { (result) in
            switch result {
            case .success(let data):
                self.output?.handleArtistSearchResult(with: .success(data.data))
            case .failure(let error):
                self.output?.handleArtistSearchResult(with: .failure(error))
            }
        }
    }
    
    func searchTrack(at key: String) {
        let service = ApiService<ApiResponseWithInData<[SearchTrackResponse]>>()
        let request = TrackSearchRequest(key: key)
        service.getData(request: request) { (result) in
            switch result {
            case .success(let data):
                self.output?.handleTrackSearchResult(with: .success(data.data))
            case .failure(let error):
                self.output?.handleTrackSearchResult(with: .failure(error))
            }
        }
    }
}
