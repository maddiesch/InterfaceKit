//
//  InterfaceNetworking.swift
//  
//
//  Created by Maddie Schipper on 3/4/21.
//

import Foundation
import Combine

public var InterfaceSession: URLSession = {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.timeoutIntervalForRequest = 10.0
    configuration.timeoutIntervalForResource = 10.0
    configuration.requestCachePolicy = .returnCacheDataElseLoad
    
    return URLSession(configuration: configuration)
}()

extension URLSession.DataTaskPublisher {
    public func requireOkayResponse() -> AnyPublisher<URLSession.DataTaskPublisher.Output, Error> {
        return self.require(httpStatusWithinRange: (200..<300))
    }
    
    public func require(httpStatusWithinRange range: Range<Int>) -> AnyPublisher<URLSession.DataTaskPublisher.Output, Error> {
        return self.tryMap { (data, response) -> URLSession.DataTaskPublisher.Output in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            guard range.contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
            
            return URLSession.DataTaskPublisher.Output(data, response)
        }.eraseToAnyPublisher()
    }
}
