//
//  ArtistListRequest.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 26.09.2020.
//

import Foundation

struct ArtistListRequest: ApiRequestProtocol {
    var method: HttpMethod
    var url: String
    var body: Encodable?
    
    init(id: String) {
        method = .GET
        url = Constant.baseUrl + "genre" + "/\(id)" + "/artists"
        body = nil
    }
}
