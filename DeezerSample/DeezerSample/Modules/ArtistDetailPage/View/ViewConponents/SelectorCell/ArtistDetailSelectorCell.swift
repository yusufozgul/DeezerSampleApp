//
//  ArtistDetailSelectorCell.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 27.09.2020.
//

import UIKit

protocol ArtistDetailSelectorCellDelegate: class {
    func indexChanged(to index: Int)
}

class ArtistDetailSelectorCell: UICollectionViewCell {
    static let reuseIdentifier: String = "ArtistDetailSelectorCell"
    @IBOutlet weak var indexSelector: UISegmentedControl!
    
    weak var delegate: ArtistDetailSelectorCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        indexSelector.setTitle("INDEX_ALBUMS".localized, forSegmentAt: 0)
        indexSelector.setTitle("INDEX_RELATED_ARTISTS".localized, forSegmentAt: 1)
    }

    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        delegate?.indexChanged(to: sender.selectedSegmentIndex)
    }
}
