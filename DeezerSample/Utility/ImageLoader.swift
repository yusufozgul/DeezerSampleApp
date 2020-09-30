//
//  ImageLoader.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 26.09.2020.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func loadImage(from urlString: String) {
        if let url = URL(string: urlString) {
            DispatchQueue.main.async {
                ImageCache.default.cleanExpiredDiskCache()
            }
            let options: KingfisherOptionsInfo = [.diskCacheExpiration(.days(3))]
            self.kf.setImage(with: url, options: options)
        }
    }
}

class LoadAlbumImage {
    class func load(from urlString: String, imageResult: @escaping (UIImage) -> Void) {
        let defaultImage = UIImage(systemName: "music.quarternote.3")!
        KingfisherManager.shared.retrieveImage(with: URL(string: urlString)!) { (result) in
            switch result {
            case .success(let image):
                print(image.image)
            case .failure(let error):
                print(error)
                imageResult(defaultImage)
            }
        }
    }
}
