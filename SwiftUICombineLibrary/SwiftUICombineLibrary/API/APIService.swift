//
//  APIService.swift
//  SwiftUICombineLibrary
//
//  Created by Georgi Pashov on 3.02.23.
//

import Foundation
import Combine

class APIService {
    class func requestDataPublisher<T: Decodable>(urlString: String, destinationType: T.Type) -> AnyPublisher<T, Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: APIError.invalidRequestError("URL invalid"))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            // Handle URL errors (most likely not able to connect to the server)
            .mapError { error in
                return APIError.transportError(error)
            }
            
            // Handle all other errors
            .tryMap { (data, response) -> (data: Data, response: URLResponse) in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                switch httpResponse.statusCode {
                case 200 ..< 300:
                    break
                case 400:
                    throw APIError.validationError(String(decoding: data, as: UTF8.self))
                case 500 ..< 600:
                    let retryAfter = httpResponse.value(forHTTPHeaderField: "Retry-After")
                    throw APIError.serverError(statusCode: httpResponse.statusCode, reason: String(decoding: data, as: UTF8.self), retryAfter: retryAfter)
                default:
                    break
                }
                
                return (data, response)
            }
            
            // Retry
            .retry(3)
            
            // Data
            .map(\.data)
            
            // Catch decoding error
            .tryMap { data -> T in
                if T.self is Data.Type {
                    return data as! T
                    
                } else {
                    do {
                        let decoder = JSONDecoder()
                        return try decoder.decode(destinationType, from: data)
                    } catch {
                        throw APIError.decodingError(data, error)
                    }
                }
            }
            
            .eraseToAnyPublisher()
    }
}
