//
//  PlayerBar.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 28.09.2020.
//

import UIKit

protocol PlayerBarDelegate: class {
    func tapPlayPause()
    func tapForward()
    func tapVolume()
}

class PlayerBar: UIView {
    @IBOutlet weak var trackArtwork: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    weak var delegate: PlayerBarDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(title: String, image: UIImage) {
        trackName.text = title
        trackArtwork.image = image
    }
    
    func updatePlayButton(to isPlaying: Bool) {
        playButton.setImage(isPlaying ? UIImage(systemName: "pause.fill") : UIImage(systemName: "play.fill"), for: .normal)
    }
    
    @IBAction func tapPlayPause(_ sender: Any) {
        delegate?.tapPlayPause()
    }
    @IBAction func tapForward(_ sender: Any) {
        delegate?.tapForward()
    }
    @IBAction func tapVolume(_ sender: Any) {
        delegate?.tapVolume()
    }
}
