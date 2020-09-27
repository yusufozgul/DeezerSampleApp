//
//  ArtistDetailPagePresenter.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 27.09.2020.
//

import Foundation
import UIKit.NSDiffableDataSourceSectionSnapshot

typealias ArtistDetailPageSnapshot = NSDiffableDataSourceSnapshot<ArtistDetailSection, ArtistDetailSectionData>

enum ArtistDetailSectionData: Hashable {
    case main(ArtistResponse)
    case selector
    case albums(AlbumResponse)
    case related(ArtistResponse)
}

class ArtistDetailPagePresenter {
    weak var view: ArtistDetailPageViewProtocol?
    private let interactor: ArtistDetailPageInteractorProtocol
    private let router: ArtistDetailRouterProtocol
    
    private(set) var artistDetail: [ArtistResponse] = []
    private(set) var artistAlbums: [AlbumResponse] = []
    private(set) var artistRelated: [ArtistResponse] = []
    private(set) var currentPageIndex: ArtistDetailSection = .albums
    private(set) var snapshot = ArtistDetailPageSnapshot()
    
    private let artistID: String
    
    init(view: ArtistDetailPageViewProtocol, interactor: ArtistDetailPageInteractorProtocol, router: ArtistDetailRouterProtocol, artistID: String) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.artistID = artistID
    }
}

extension ArtistDetailPagePresenter: ArtistDetailPagePresenterProtocol {
    func viewDidLoad() {
        view?.prepareUI()
        snapshot.appendSections([.main, .selector])
        interactor.getArtistDetail(at: artistID)
        interactor.getArtistAlbums(at: artistID)
    }
    
    func changeIndex(to index: Int) {
        if index == 0 {
            currentPageIndex = .albums
            interactor.getArtistAlbums(at: artistID)
        } else if index == 1 {
            currentPageIndex = .related
            interactor.getArtistRelated(at: artistID)
        }
    }
    
    func selectItem(at index: Int) {
        if currentPageIndex == .albums {
            let id = artistAlbums[index].id
            router.navigateToAlbumdetail(to: String(id))
        } else if currentPageIndex == .related {
            let id = artistRelated[index].id
            router.navigateToArtistsDetail(to: String(id))
        }
    }
}

extension ArtistDetailPagePresenter: ArtistDetailInteractorOutput {
    func handleDetailResult(with result: Result<ArtistResponse, ApiError>) {
        switch result {
        case .success(let artistDetail):
            self.artistDetail = [artistDetail]
            snapshot.appendItems([.main(artistDetail)], toSection: .main)
            snapshot.appendItems([.selector], toSection: .selector)
            view?.updateCollectionView(with: snapshot)
            view?.setTitle(title: artistDetail.name)
        case .failure(let error):
            view?.showError(errorDescription: error.localizedDescription)
        }
        view?.setLoading(isLoading: false)
    }
    
    func handleAlbumsResult(with result: Result<[AlbumResponse], ApiError>) {
        switch result {
        case .success(let artistAlbums):
            self.artistAlbums = artistAlbums
            if self.currentPageIndex == .albums {
                snapshot.appendSections([.albums])
                snapshot.deleteSections([.related])
                artistAlbums.forEach({ snapshot.appendItems([.albums($0)], toSection: .albums)})
                view?.updateCollectionView(with: snapshot)
            }
        case .failure(let error):
            view?.showError(errorDescription: error.localizedDescription)
        }
    }
    
    func handleRelatedResult(with result: Result<[ArtistResponse], ApiError>) {
        switch result {
        case .success(let artistRelated):
            self.artistRelated = artistRelated
            if self.currentPageIndex == .related {
                snapshot.appendSections([.related])
                snapshot.deleteSections([.albums])
                artistRelated.forEach({ snapshot.appendItems([.related($0)], toSection: .related)})
                view?.updateCollectionView(with: snapshot)
            }
        case .failure(let error):
            view?.showError(errorDescription: error.localizedDescription)
        }
    }
}
