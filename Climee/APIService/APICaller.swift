//
//  APICaller.swift
//  Climee
//
//  Created by Nuntapat Hirunnattee on 12/11/2565 BE.
//

import Foundation
enum NetworkError: Error{
    case invalidURL
    case invalidData
    case invalidDecodeData
}

final class APICaller{

    static let shared = APICaller()
    
    init(){ }
    
    func request<T: Codable>(urlString: String, expecting: T.Type, completions: @escaping (Result<T, Error>) -> Void){
        guard let url = URL(string: urlString) else {
            completions(.failure(NetworkError.invalidURL))
            return
        }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completions(.failure(NetworkError.invalidData))
                return
            }
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completions(.success(result))
            } catch {
                completions(.failure(NetworkError.invalidDecodeData))
            }
        }
        task.resume()
    }
}
