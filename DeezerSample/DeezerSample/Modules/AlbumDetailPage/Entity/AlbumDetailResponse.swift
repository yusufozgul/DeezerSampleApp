//
//  AlbumDetailResponse.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 26.09.2020.
//

import Foundation

struct AlbumDetailResponse: Decodable {
    let id: Int
    let title: String
    let cover: String
    let coverSmall: String
    let coverMedium: String
    let coverBig: String
    let coverXl: String
    let fans: Int
    let tracks: TrackDetailDataResponse
    
    enum CodingKeys: String, CodingKey {
        case id, title, cover, fans, tracks
        case coverSmall = "cover_small"
        case coverMedium = "cover_medium"
        case coverBig = "cover_big"
        case coverXl = "cover_xl"
    }
}

struct TrackDetailDataResponse: Decodable {
    let data: [TrackDetailResponse]
}

struct TrackDetailResponse: Decodable {
    let id: Int
    let title: String
    let duration: Int
    let preview: String
}

struct AlbumDetailTrackListData: Hashable {
    var albumImage: String
    let title: String
    let duration: Int
    let preview: String
}
