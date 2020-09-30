//
//  SearchResponse.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 26.09.2020.
//

import Foundation

typealias SearchResponseArtist = ArtistResponse

typealias SearchAlbumResponse = SearchTrackResponseAlbumData
typealias SearchArtistResponse = SearchTrackResponseArtistData

struct SearchTrackResponse: Decodable, Hashable {
    let id: Int
    let title: String
    let preview: String
    let album: SearchTrackResponseAlbumData
    let artist: SearchTrackResponseArtistData
}

struct SearchTrackResponseAlbumData: Decodable, Hashable {
    let id: Int
    let title: String
    let cover: String
    let coverXl: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, cover
        case coverXl = "cover_xl"
    }
}

struct SearchTrackResponseArtistData: Decodable, Hashable {
    let id: Int
    let name: String
    let pictureXl: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case pictureXl = "picture_xl"
    }
}
