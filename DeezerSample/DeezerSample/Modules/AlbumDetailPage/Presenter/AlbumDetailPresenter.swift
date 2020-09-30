//
//  AlbumDetailPresenter.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 27.09.2020.
//

import Foundation
import UIKit.NSDiffableDataSourceSectionSnapshot

typealias AlbumDetailPageSnapshot = NSDiffableDataSourceSnapshot<AlbumDetailSection, AlbumDetailTrackListData>

class AlbumDetailPresenter {
    weak var view: AlbumDetailPageViewProtocol?
    private let interactor: AlbumDetailInteractorProtocol
    private let router: AlbumDetailRouterProtocol
    private(set) var trackList: [AlbumDetailTrackListData] = []
    private let albumID: String
    private let albumName: String
    
    init(view: AlbumDetailPageViewProtocol, interactor: AlbumDetailInteractorProtocol, router: AlbumDetailRouterProtocol, albumID: String, albumName: String) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.albumID = albumID
        self.albumName = albumName
    }
    
    var player: MusicPlayerProtocol?
}

extension AlbumDetailPresenter: AlbumDetailPresenterProtocol {
    func selectTrack(at index: Int) {
        var sortedList = trackList
        sortedList.insert(sortedList.remove(at: index), at: 0)
        player = MusicPlayer.player
        player?.setTrackList(trackItems: sortedList)
        player?.play()
    }
    
    func viewDidLoad() {
        view?.prepareUI()
        view?.setTitle(title: albumName)
        interactor.getTracks(at: albumID)
        view?.setLoading(isLoading: true)
    }
    
    func favoriteTrack(at index: Int) {
        DataBaseController.shared.save(data: trackList[index]) { result in
            switch result {
            case .success(_):
                break
            case .failure(_):
                break
            }
        }
    }
    
    func shareTrack(at index: Int) {
        print("share")
    }
}

extension AlbumDetailPresenter: AlbumDetailInteractorOutput {
    func handleAlbumDetail(with result: Result<AlbumDetailResponse, ApiError>) {
        switch result {
        case .success(let response):
            self.trackList = response.tracks.data.map({ AlbumDetailTrackListData(albumImage: response.coverXl,
                                                                                 title: $0.title,
                                                                                 duration: $0.duration,
                                                                                 preview: $0.preview,
                                                                                 artistName: response.title,
                                                                                 albumName: response.artist.name)})
            var snapshot = AlbumDetailPageSnapshot()
            snapshot.appendSections([.main])
            snapshot.appendItems(self.trackList, toSection: .main)
            view?.showTrackList(with: snapshot)
        case .failure(let error):
            view?.showError(errorDescription: error.localizedDescription)
        }
        view?.setLoading(isLoading: false)
    }
}
