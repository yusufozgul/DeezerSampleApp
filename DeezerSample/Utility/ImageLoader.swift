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
