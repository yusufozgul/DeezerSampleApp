//
//  SearchPagePresenter.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 28.09.2020.
//

import Foundation
import UIKit.NSDiffableDataSourceSectionSnapshot

typealias SearchPageSnapshot = NSDiffableDataSourceSnapshot<SearchPageSection, SearchPageSectionData>

enum SearchPageSectionData: Hashable {
    case album(SearchTrackResponseAlbumData)
    case artist(SearchTrackResponseArtistData)
    case track(AlbumDetailTrackListData)
}

class SearchPagePresenter {
    weak var view: SearchPageViewProtocol?
    private let interactor: SearchPageInteractorProtocol
    private let router: SearchPageRouterProtocol
    
    private(set) var artistResult: [SearchTrackResponseArtistData] = []
    private(set) var albumResult: [SearchTrackResponseAlbumData] = []
    private(set) var trackResult: [AlbumDetailTrackListData] = []
    private(set) var snapshot = SearchPageSnapshot()
    
    init(view: SearchPageViewProtocol, interactor: SearchPageInteractorProtocol, router: SearchPageRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
        snapshot.appendSections([.artist, .album, .track])
    }
}

extension SearchPagePresenter: SearchPagePresenterProtocol {
    func viewDidLoad() {
        view?.prepareUI()
        view?.setTitle(title: "SEARCH_VC_TITLE".localized)
    }
    
    func selectItem(at indexPath: IndexPath) {
        
    }
    
    func search(with key: String) {
        view?.setLoading(isLoading: true)
        interactor.searchAlbum(at: key)
        interactor.searchTrack(at: key)
        interactor.searchArtist(at: key)
    }
}

extension SearchPagePresenter: SearchPageInteractorOutput {
    func handleAlbumSearchResult(with result: Result<[SearchAlbumResponse], ApiError>) {
        switch result {
        case .success(let albumResult):
            self.albumResult = albumResult
            albumResult.forEach({ snapshot.appendItems([.album($0)], toSection: .album) })
            view?.updateCollectionView(with: snapshot)
        case .failure(let error):
            view?.showError(errorDescription: error.localizedDescription)
        }
        view?.setLoading(isLoading: false)
    }
    
    func handleArtistSearchResult(with result: Result<[SearchArtistResponse], ApiError>) {
        switch result {
        case .success(let artistResult):
            self.artistResult = artistResult
            artistResult.forEach({ snapshot.appendItems([.artist($0)], toSection: .artist) })
            view?.updateCollectionView(with: snapshot)
        case .failure(let error):
            view?.showError(errorDescription: error.localizedDescription)
        }
    }
    
    func handleTrackSearchResult(with result: Result<[SearchTrackResponse], ApiError>) {
        switch result {
        case .success(let trackResult):
            self.trackResult = trackResult.map({ AlbumDetailTrackListData(albumImage: $0.album.coverXl,
                                                                           title: $0.title,
                                                                           duration: 0,
                                                                           preview: $0.preview,
                                                                           artistName: $0.title,
                                                                           albumName: $0.artist.name)})
            self.trackResult.forEach({ snapshot.appendItems([.track($0)], toSection: .track)})
            view?.updateCollectionView(with: snapshot)
        case .failure(let error):
            view?.showError(errorDescription: error.localizedDescription)
        }
    }
}
