//
//  AlbumDetailInteractor.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 27.09.2020.
//

import Foundation

class AlbumDetailInteractor {
    weak var output: AlbumDetailInteractorOutput?
}

extension AlbumDetailInteractor: AlbumDetailInteractorProtocol {
    func getTracks(at id: String) {
        let service = ApiService<AlbumDetailResponse>()
        let request = AlbumDetailRequest(id: id)
        service.getData(request: request) { (result) in
            switch result {
            case .success(let data):
                self.output?.handleAlbumDetail(with: .success(data))
            case .failure(let error):
                self.output?.handleAlbumDetail(with: .failure(error))
            }
        }
    }
}
