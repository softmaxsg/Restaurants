//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation

enum RestaurantsProviderError: Error {
    
    case unknwon
    
}

protocol RestaurantsProviderProtocol {
    
    @discardableResult
    func loadAll(completion handler: @escaping (Result<[Restaurant]>) -> Void) -> Cancellable
    
}

final class RestaurantsProvider: RestaurantsProviderProtocol {

    private let urlSession: URLSessionProtocol
    private let jsonDecoder: JSONDecoderProtocol
    private var urlRequest: URLRequest { return URLRequest(url: Constants.restaurantsURL) }
    
    init(urlSession: URLSessionProtocol = URLSessionMock(), jsonDecoder: JSONDecoderProtocol = JSONDecoder()) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }
    
    @discardableResult
    func loadAll(completion handler: @escaping (Result<[Restaurant]>) -> Void) -> Cancellable {
        let jsonDecoder = self.jsonDecoder
        let task = urlSession.dataTask(with: urlRequest) { (data, urlResponse, error) in
            guard let data = data, let httpResponse = urlResponse as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                handler(.failure(error ?? RestaurantsProviderError.unknwon))
                return
            }
            
            do {
                let response = try jsonDecoder.decode(RestaurantsResponse.self, from: data)
                handler(.success(response.restaurants))
            } catch let decodingError {
                handler(.failure(decodingError))
            }
        }
        
        task.resume()
        return task
    }
}
