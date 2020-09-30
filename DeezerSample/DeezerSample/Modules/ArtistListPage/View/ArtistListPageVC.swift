//
//  ArtistListPageVC.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 27.09.2020.
//

import UIKit

private typealias DataSource = UICollectionViewDiffableDataSource<ArtistListSection, ArtistResponse>

enum ArtistListSection {
    case main
}

class ArtistListPageVC: UIViewController {
    var presenter: ArtistListPagePresenterProtocol!
    private var collectionView: UICollectionView!
    private var loadingIndicator: UIActivityIndicatorView!
    private var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension ArtistListPageVC: ArtistListPageVCProtocol {
    func prepareUI() {
        makeCollectionView()
        setActiviyIndicator()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    func setTitle(title: String) {
        self.title = "ARTIST_LIST_TITLE".localized + ": " + title
    }
    
    func showArtistList(with snapshot: ArtistListPageSnapshot) {
        dataSource.apply(snapshot, animatingDifferences: true)
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

extension ArtistListPageVC {
    func setActiviyIndicator() {
        loadingIndicator = UIActivityIndicatorView()
        self.view.addSubview(loadingIndicator)
        loadingIndicator.center = self.view.center
        loadingIndicator.hidesWhenStopped = true
    }
}

extension ArtistListPageVC {
    func makeCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.register(UINib.loadNib(name: GridCardView.reuseIdentifier), forCellWithReuseIdentifier: GridCardView.reuseIdentifier)
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, data) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCardView.reuseIdentifier, for: indexPath) as? GridCardView
            cell?.setView(label: data.name)
            cell?.image.loadImage(from: data.pictureXl)
            return cell
        })
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5))
            let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
            layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
            let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
            let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
            layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            return layoutSection
        }
        return layout
    }
}

extension ArtistListPageVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.selectArtist(at: indexPath.row)
    }
}
