//
//  GenreListRequest.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 26.09.2020.
//

import Foundation

struct GenreListRequest: ApiRequestProtocol {
    var method: HttpMethod
    var url: String
    var body: Encodable?
    
    init() {
        method = .GET
        url = Constant.baseUrl + "genre"
        body = nil
    }
}
