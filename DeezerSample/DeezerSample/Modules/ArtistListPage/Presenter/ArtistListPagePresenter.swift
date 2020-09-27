//
//  ArtistListPagePresenter.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 27.09.2020.
//

import Foundation

import UIKit.NSDiffableDataSourceSectionSnapshot

typealias ArtistListPageSnapshot = NSDiffableDataSourceSnapshot<ArtistListSection, ArtistResponse>

class ArtistListPagePresenter {
    weak var view: ArtistListPageVCProtocol?
    private let interactor: ArtistListPageInteractorProtocol
    private let router: ArtistListPageRouterProtocol
    private(set) var genreList: [ArtistResponse] = []
    private let genreID: String
    
    init(view: ArtistListPageVCProtocol, interactor: ArtistListPageInteractorProtocol, router: ArtistListPageRouterProtocol, genreID: String) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.genreID = genreID
    }
}

extension ArtistListPagePresenter: ArtistListPagePresenterProtocol {
    func selectArtist(at index: Int) {
        let id = genreList[index].id
        router.navigateToArtistsDetail(to: String(id))
    }
    
    func viewDidLoad() {
        view?.prepareUI()
        interactor.getArtists(at: genreID)
        view?.setLoading(isLoading: true)
    }
}

extension ArtistListPagePresenter: ArtistListInteractorOutput {
    func handleSearchResult(with result: Result<[ArtistResponse], ApiError>) {
        switch result {
        case .success(let artisteList):
            self.genreList = artisteList
            var snapshot = ArtistListPageSnapshot()
            snapshot.appendSections([.main])
            snapshot.appendItems(artisteList, toSection: .main)
            view?.showArtistList(with: snapshot)
        case .failure(let error):
            view?.showError(errorDescription: error.localizedDescription)
        }
        view?.setLoading(isLoading: false)
    }
}
