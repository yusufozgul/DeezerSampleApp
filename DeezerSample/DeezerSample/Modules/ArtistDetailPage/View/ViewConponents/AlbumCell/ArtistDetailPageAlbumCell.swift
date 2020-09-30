//
//  ArtistDetailPageAlbumCell.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 27.09.2020.
//

import UIKit

class ArtistDetailPageAlbumCell: UICollectionViewCell {
    static let reuseIdentifier: String = "ArtistDetailPageAlbumCell"
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumReleaseDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        albumImage.clipsToBounds = true
        albumImage.layer.cornerRadius = 8
    }
    
    func setData(title: String, date: String) {
        albumName.text = title
        albumReleaseDate.text = date
    }

}
