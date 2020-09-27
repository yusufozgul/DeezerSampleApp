//
//  ArtistDetailHeaderCell.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 27.09.2020.
//

import UIKit

class ArtistDetailHeaderCell: UICollectionViewCell {
    static let reuseIdentifier: String = "ArtistDetailHeaderCell"
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak private var infoView: UIView!
    @IBOutlet weak private var albumCountLabel: UILabel!
    @IBOutlet weak private var fanCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        infoView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)
        infoView.layer.cornerRadius = 8
        albumCountLabel.textColor = .white
        fanCountLabel.textColor = .white
        headerImage.contentMode = .scaleAspectFit
    }
    
    func setDetail(albumCount: String, fanCount: String) {
        self.albumCountLabel.text = albumCount
        self.fanCountLabel.text = fanCount
    }
}
