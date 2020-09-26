//
//  GridCardView.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 26.09.2020.
//

import UIKit

class GridCardView: UICollectionViewCell {
    static let reuseIdentifier: String = "GridCardView"
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
        label.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)
        label.textColor = .white
        image.contentMode = .scaleAspectFill
    }
    
    func setView(label: String) {
        self.label.text = label
    }
    
}
