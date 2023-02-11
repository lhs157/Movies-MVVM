//
//  Requestable.swift
//  MovieListMVVM
//
//  Created by mac on 11/02/2023.
//

import Foundation
import Alamofire

protocol Requestable: URLRequestConvertible {
    var parameters: Parameters? { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var header: [String: String] { get }
    var encoding: Alamofire.ParameterEncoding { get }
}

extension Requestable {
    
    var parameters: Parameters? {
        return getBaseParams()
    }
    
    var header: [String: String] {
        return ["Content-Type":"application/json", "Accept":"application/json"]
    }
    
    public func getBaseUrl() -> String {
        return NetworkConstants.baseUrl
    }
    
    public func getBaseParams() -> Parameters {
        return ["apikey": NetworkConstants.API_KEY]
    }
    
    
    public func asURLRequest() throws -> URLRequest {
        let url = try getBaseUrl().asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = header
        //Encoding
        printURLPretty(urlRequest)
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    func printURLPretty(_ urlRequest: URLRequest?) {
        print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        print("header: \(String(describing: urlRequest?.headers)))")
        print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        print("Parameters: \(String(describing: parameters))")
        print("Headers: \(String(describing: header))")
        if let jsonBody = urlRequest?.httpBody {
            print("JSON: \(String(describing: String(data: jsonBody, encoding: .utf8)))")
        }
        print("URL: \(String(describing: urlRequest?.url?.absoluteString))")
        print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
    }
}
