//
//  ApiResponse.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 26.09.2020.
//

import Foundation

/// Some list data return inside `data` field
struct ApiResponseWithInData<T: Decodable>: Decodable {
    let data: T
}

/// Generic Deezer Api error response type
struct ApiResponseError: Decodable {
    let type: String
    let message: String
    let code: Int
}
