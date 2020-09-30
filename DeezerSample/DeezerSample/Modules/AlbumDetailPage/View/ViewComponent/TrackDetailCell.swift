//
//  TrackDetailCell.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 27.09.2020.
//

import UIKit

protocol TrackDetailCellDelegate: class {
    func tapFavorite(index: Int)
    func tapShare(index: Int)
}

class TrackDetailCell: UICollectionViewCell {
    static let reuseIdentifier: String = "TrackDetailCell"
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var trackDuration: UILabel!
    
    weak var delegate: TrackDetailCellDelegate?
    
    var index: Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(name: String, duration: String, index: Int) {
        trackTitle.text = name
        trackDuration.text = duration
        self.index = index
    }

    @IBAction func tapFavorite(_ sender: Any) {
        delegate?.tapFavorite(index: index)
    }
    @IBAction func tapShare(_ sender: Any) {
        delegate?.tapShare(index: index)
    }
}
