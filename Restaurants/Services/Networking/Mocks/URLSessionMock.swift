//
//  Copyright © 2018 Vitaly Chupryk. All rights reserved.
//

import Foundation

final class URLSessionMock: URLSessionProtocol {

    private enum Request {
        
        case url(URL?)
        case data(Data?)
        
    }

    private class URLSessionDataTaskMock: URLSessionDataTaskProtocol {

        private enum URLSessionDataTaskMockError: Error {
            
            case badRequest
            
        }

        typealias OperationResult = (data: Data?, response: URLResponse?, error: Error?)
        
        private let operationQueue = OperationQueue()
        private let request: Request
        private let completionHandler: DataTaskHandler
        
        init(request: Request, completion handler: @escaping DataTaskHandler) {
            self.request = request
            self.completionHandler = handler
        }
        
        func resume() {
            operationQueue.addOperation {
                let result: OperationResult
                
                switch self.request {
                case .url(let url):
                    result = self.load(from: url)
                case .data(let data):
                    let response = HTTPURLResponse(url: URL(string: "mock://data")!, statusCode: 200, httpVersion: nil, headerFields: nil)
                    result = (data, response, nil)
                }

                self.completionHandler(result.data, result.response, result.error)
            }
        }
        
        func cancel() {
            //
        }
        
        private func load(from url: URL?) -> OperationResult {
            guard let url = url else { return (nil, nil, URLSessionDataTaskMockError.badRequest) }
            
            var result: OperationResult
            let statusCode: Int

            do {
                // Here a delay can be added in order to see the loading state in the restaurants view comtroller
                // like Thread.sleep(forTimeInterval: 1)

                // Also an error can be thrown in order to see the error state in the restaurants view comtroller
                // like throw URLSessionDataTaskMockError.badRequest
                
                result.data = try Data(contentsOf: url)
                result.error = nil
                statusCode = 200
            } catch (let error) {
                result.data = nil
                result.error = error
                statusCode = 404
            }
            
            result.response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)
            return result
        }
        
    }

    private let urlsMap: [URL: Request]
    
    init(map urlsMap: [URL: URL] = [Constants.restaurantsURL: Constants.restaurantsMockURL]) {
        self.urlsMap = urlsMap.mapValues { .url($0) }
    }

    // For testing purpose
    init(map urlsMap: [URL: Data?]) {
        self.urlsMap = urlsMap.mapValues { .data($0) }
    }

    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping DataTaskHandler) -> URLSessionDataTaskProtocol {
        let request = (urlRequest.url != nil ? urlsMap[urlRequest.url!] : nil) ?? .data(nil)
        return URLSessionDataTaskMock(request: request, completion: completionHandler)
    }

}
