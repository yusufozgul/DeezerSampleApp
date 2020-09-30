//
//  SearchRequest.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 26.09.2020.
//

import Foundation

struct AlbumSearchRequest: ApiRequestProtocol {
    var method: HttpMethod
    var url: String
    var body: Encodable?
    
    init(key: String) {
        method = .GET
        url = Constant.baseUrl + "search/album?q=" + key
        body = nil
    }
}

struct ArtistSearchRequest: ApiRequestProtocol {
    var method: HttpMethod
    var url: String
    var body: Encodable?
    
    init(key: String) {
        method = .GET
        url = Constant.baseUrl + "search/artist?q=" + key
        body = nil
    }
}

struct TrackSearchRequest: ApiRequestProtocol {
    var method: HttpMethod
    var url: String
    var body: Encodable?
    
    init(key: String) {
        method = .GET
        url = Constant.baseUrl + "search/track?q=" + key
        body = nil
    }
}
