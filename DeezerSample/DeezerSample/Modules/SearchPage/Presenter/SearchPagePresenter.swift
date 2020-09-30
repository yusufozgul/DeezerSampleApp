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

class SearchPagePresenter: NSObject {
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
        if indexPath.section == 0 {
            let selected = artistResult[indexPath.row]
            router.navigateToArtistsDetail(to: String(selected.id))
        } else if indexPath.section == 1 {
            let selected = albumResult[indexPath.row]
            router.navigateToAlbumdetail(to: String(selected.id), name: selected.title)
        } else if indexPath.section == 2 {
            let selected = trackResult[indexPath.row]
            let player = MusicPlayer.player
            player.setTrackList(trackItems: [selected])
            player.play()
        }
    }
    
    func search(with key: String) {
        guard key != "" else {
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            removeDataSourceItems(.artist)
            removeDataSourceItems(.track)
            removeDataSourceItems(.album)
            view?.updateCollectionView(with: snapshot)
            return
        }
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.perform(#selector(self.requestSearch(key:)), with: key, afterDelay: 0.5)
    }
    
    @objc
    private func requestSearch(key: String) {
        view?.setLoading(isLoading: true)
        interactor.searchAlbum(at: key)
        interactor.searchTrack(at: key)
        interactor.searchArtist(at: key)
    }
    
    func favoriteTrack(at index: Int) {
        DataBaseController.shared.save(data: trackResult[index]) { result in
            switch result {
            case .success(_):
                break
            case .failure(_):
                break
            }
        }
    }
    
    func shareTrack(at index: Int) {
        
    }
}

extension SearchPagePresenter: SearchPageInteractorOutput {
    func handleAlbumSearchResult(with result: Result<[SearchAlbumResponse], ApiError>) {
        switch result {
        case .success(let albumResult):
            self.removeDataSourceItems(.album)
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
            self.removeDataSourceItems(.artist)
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
            self.removeDataSourceItems(.track)
            self.trackResult = trackResult.map({ AlbumDetailTrackListData(albumImage: $0.album.coverXl ?? $0.album.cover,
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
    
    private func removeDataSourceItems(_ section: SearchPageSection) {
        switch section {
        case .artist:
            self.artistResult.forEach({ self.snapshot.deleteItems([.artist($0)])})
        case .album:
            self.albumResult.forEach({ self.snapshot.deleteItems([.album($0)])})
        case .track:
            self.trackResult.forEach({ self.snapshot.deleteItems([.track($0)])})
        }
    }
}
