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
    let coverSmall: String
    let coverMedium: String
    let coverBig: String
    let coverXl: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, cover
        case coverSmall = "cover_small"
        case coverMedium = "cover_medium"
        case coverBig = "cover_big"
        case coverXl = "cover_xl"
    }
}

struct SearchTrackResponseArtistData: Decodable, Hashable {
    let id: Int
    let name: String
    let picture: String
    let pictureSmall: String
    let pictureMedium: String
    let pictureBig: String
    let pictureXl: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, picture
        case pictureSmall = "picture_small"
        case pictureMedium = "picture_medium"
        case pictureBig = "picture_big"
        case pictureXl = "picture_xl"
    }
}
