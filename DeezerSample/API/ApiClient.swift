//
//  ApiClient.swift
//  DeezerSample
//
//  Created by Yusuf Özgül on 25.09.2020.
//

import Foundation

protocol ApiRequestProtocol {
    var method: HttpMethod { get }
    var url: String { get }
    var body: Encodable? { get }
}

/// Send netork request and return result data
class ApiService<T: Decodable> {
    /// Send netork request and return result data
    /// - Parameters:
    ///   - request: `ApiRequestProtocol` for request detail.
    ///   - completion: If `result` is error return `ApiError` otherwise return `T` type
    func getData(request: ApiRequestProtocol, completion: @escaping (Result<T, ApiError>) -> Void) {
        guard let urlString = request.url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlString) else {
            completion(.failure(.urlEncode))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body?.toJSONData()
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.network(errorMessage: error?.localizedDescription ?? "unexpected error")))
                return
            }
            if let data = data {
                completion(ParseFromData<T>.parse(data: data))
            }
        }
        task.resume()
    }
}
