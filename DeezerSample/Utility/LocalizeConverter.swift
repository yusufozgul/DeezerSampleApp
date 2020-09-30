//
//  LocalizeConverter.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 26.09.2020.
//

import Foundation

extension String {
    var localized: String { return NSLocalizedString(self, comment: self) }
}
