//
//  ArtistDetailPageVC.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 27.09.2020.
//

import Foundation
import UIKit

private typealias DataSource = UICollectionViewDiffableDataSource<ArtistDetailSection, ArtistDetailSectionData>

enum ArtistDetailSection {
    case main
    case selector
    case albums
    case related
}

class ArtistDetailPageVC: UIViewController {
    var presenter: ArtistDetailPagePresenterProtocol!
    private var collectionView: UICollectionView!
    private var loadingIndicator: UIActivityIndicatorView!
    private var dataSource: DataSource!
    private var sections: [ArtistDetailSection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension ArtistDetailPageVC: ArtistDetailPageViewProtocol {
    func prepareUI() {
        makeCollectionView()
        setActiviyIndicator()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    func setTitle(title: String) {
        DispatchQueue.main.async {
            self.title = title
        }
    }
    
    func updateCollectionView(with snapshot: ArtistDetailPageSnapshot) {
        DispatchQueue.main.sync {
            sections = snapshot.sectionIdentifiers
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.collectionViewLayout = createLayout()
            dataSource.apply(snapshot)
        }
    }
    
    func showError(errorDescription: String) {
        let alert = UIAlertController(title: "ALERT_TITLE".localized, message: errorDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ALERT_CANCEL_BUTTON_TITLE".localized, style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func setLoading(isLoading: Bool) {
        DispatchQueue.main.async { [self] in
            isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
        }
    }
}

extension ArtistDetailPageVC {
    func setActiviyIndicator() {
        loadingIndicator = UIActivityIndicatorView()
        self.view.addSubview(loadingIndicator)
        loadingIndicator.center = self.view.center
        loadingIndicator.hidesWhenStopped = true
    }
}

extension ArtistDetailPageVC: UICollectionViewDelegate {
    
    func makeCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.register(UINib.loadNib(name: ArtistDetailHeaderCell.reuseIdentifier), forCellWithReuseIdentifier: ArtistDetailHeaderCell.reuseIdentifier)
        collectionView.register(UINib.loadNib(name: ArtistDetailSelectorCell.reuseIdentifier), forCellWithReuseIdentifier: ArtistDetailSelectorCell.reuseIdentifier)
        collectionView.register(UINib.loadNib(name: ArtistDetailPageAlbumCell.reuseIdentifier), forCellWithReuseIdentifier: ArtistDetailPageAlbumCell.reuseIdentifier)
        collectionView.register(UINib.loadNib(name: GridCardView.reuseIdentifier), forCellWithReuseIdentifier: GridCardView.reuseIdentifier)

        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, data) -> UICollectionViewCell? in
            switch data {
            case .main(let data):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistDetailHeaderCell.reuseIdentifier, for: indexPath) as? ArtistDetailHeaderCell
                cell?.setDetail(albumCount: String(data.nbAlbum ?? 0), fanCount: String(data.nbFan ?? 0))
                cell?.headerImage.loadImage(from: data.pictureXl)
                return cell
            case .albums(let album):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistDetailPageAlbumCell.reuseIdentifier, for: indexPath) as? ArtistDetailPageAlbumCell
                cell?.setData(title: album.title, date: album.releaseDate)
                cell?.albumImage.loadImage(from: album.coverXl)
                return cell
            case .related(let artist):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCardView.reuseIdentifier, for: indexPath) as? GridCardView
                cell?.setView(label: artist.name)
                cell?.image.loadImage(from: artist.pictureXl)
                return cell
            case .selector:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistDetailSelectorCell.reuseIdentifier, for: indexPath) as? ArtistDetailSelectorCell
                cell?.delegate = self
                return cell
            }
        })
    }

    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch self.sections[sectionIndex] {
            case .main:
                return self.headerLayout()
            case .albums:
                return self.albumsLayout()
            case .related:
                return self.relatedArtistLayout()
            case .selector:
                return self.selectorLayout()
            }
        }
        return layout
    }
    
    private func headerLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        return layoutSection
    }
    
    private func selectorLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        return layoutSection
    }
    
    private func albumsLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(120))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        return layoutSection
    }
    
    private func relatedArtistLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        return layoutSection
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            presenter.selectItem(at: indexPath.row)
        }
    }
}

extension ArtistDetailPageVC: ArtistDetailSelectorCellDelegate {
    func indexChanged(to index: Int) {
        presenter.changeIndex(to: index)
    }
}
