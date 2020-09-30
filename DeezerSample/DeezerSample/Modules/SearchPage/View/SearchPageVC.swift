//
//  SearchPageVC.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 28.09.2020.
//

import UIKit

private typealias DataSource = UICollectionViewDiffableDataSource<SearchPageSection, SearchPageSectionData>

enum SearchPageSection {
    case artist
    case album
    case track
}

class SearchPageVC: UIViewController {
    var presenter: SearchPagePresenterProtocol!
    private var collectionView: UICollectionView!
    private var loadingIndicator: UIActivityIndicatorView!
    private var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension SearchPageVC: SearchPageViewProtocol {
    func prepareUI() {
        makeCollectionView()
        setActiviyIndicator()
        navigationItem.largeTitleDisplayMode = .never
        setSearchBar()
    }
    
    func setTitle(title: String) {
        self.title = title
    }
    
    func updateCollectionView(with snapshot: SearchPageSnapshot) {
        DispatchQueue.main.async { [weak self] in
            self?.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func showError(errorDescription: String) {
        let alert = UIAlertController(title: "ALERT_TITLE".localized, message: errorDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ALERT_CANCEL_BUTTON_TITLE".localized, style: .cancel, handler: nil))
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }
    
    func setLoading(isLoading: Bool) {
        DispatchQueue.main.async { [self] in
            isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
        }
    }
    
    func share(trackUrl: String) {
        let objectsToShare:URL = URL(string: trackUrl)!
        let sharedObjects:[AnyObject] = [objectsToShare as AnyObject]
        let activityViewController = UIActivityViewController(activityItems: sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension SearchPageVC {
    func setActiviyIndicator() {
        loadingIndicator = UIActivityIndicatorView()
        self.view.addSubview(loadingIndicator)
        loadingIndicator.center = self.view.center
        loadingIndicator.hidesWhenStopped = true
    }
    
    func setSearchBar() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "SEARCH_VC_BAR_TEXT".localized
        navigationItem.searchController = search
    }
}

extension SearchPageVC: UICollectionViewDelegate {
    func makeCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.register(UINib.loadNib(name: ArtistDetailPageAlbumCell.reuseIdentifier), forCellWithReuseIdentifier: ArtistDetailPageAlbumCell.reuseIdentifier)
        collectionView.register(UINib.loadNib(name: GridCardView.reuseIdentifier), forCellWithReuseIdentifier: GridCardView.reuseIdentifier)
        collectionView.register(UINib.loadNib(name: TrackDetailCell.reuseIdentifier), forCellWithReuseIdentifier: TrackDetailCell.reuseIdentifier)
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: "UICollectionViewCell", withReuseIdentifier: "UICollectionViewCell")
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, data) -> UICollectionViewCell? in
            switch data {
            case .album(let data):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistDetailPageAlbumCell.reuseIdentifier, for: indexPath) as? ArtistDetailPageAlbumCell
                cell?.setData(title: data.title, date: data.title)
                cell?.albumImage.loadImage(from: data.coverXl ?? data.cover)
                return cell
            case .artist(let data):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCardView.reuseIdentifier, for: indexPath) as? GridCardView
                cell?.setView(label: data.name)
                cell?.image.loadImage(from: data.pictureXl)
                return cell
            case .track(let data):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackDetailCell.reuseIdentifier, for: indexPath) as? TrackDetailCell
                cell?.setData(name: data.title, duration: String(data.duration), index: indexPath.row)
                cell?.trackImage.loadImage(from: data.albumImage)
                cell?.delegate = self
                cell?.index = indexPath.row
                return cell
            }
        })
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UICollectionViewCell", for: indexPath)
            cell.subviews.forEach({$0.removeFromSuperview()})
            let label = UILabel()
            switch indexPath.section {
            case 0:
                label.text = "ARTIST_SECTION".localized
            case 1:
                label.text = "ALBUM_SECTION".localized
            case 2:
                label.text = "TRACK_SECTION".localized
            default:
                label.text = ""
            }
            label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
            label.sizeToFit()
            label.translatesAutoresizingMaskIntoConstraints = false
            cell.addSubview(label)
            label.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
            label.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 5).isActive = true
            return cell
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
            case 0:
                return self.cardLayout()
            case 1:
                return self.albumLayout()
            case 2:
                return self.trackLayout()
            default:
                return self.trackLayout()
            }
        }
        return layout
    }
    
    
    private func cardLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        let layoutSectionHeader = sectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        return layoutSection
    }
    
    private func albumLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(120))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem, layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        layoutSection.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        let layoutSectionHeader = sectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        return layoutSection
    }
    
    private func trackLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(100))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem, layoutItem, layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 20)
        layoutSection.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        let layoutSectionHeader = sectionHeader()
        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
        return layoutSection
    }
    
    private func sectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(45))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: "UICollectionViewCell", alignment: .top)
        return layoutSectionHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.selectItem(at: indexPath)
    }
}

extension SearchPageVC: TrackDetailCellDelegate {
    func tapFavorite(index: Int) {
        presenter.favoriteTrack(at: index)
    }
    
    func tapShare(index: Int) {
        presenter.shareTrack(at: index)
    }
}

extension SearchPageVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        presenter.search(with: searchController.searchBar.text!)
    }
}
