//
//  APIRequest.swift
//  MovieListMVVM
//
//  Created by mac on 11/02/2023.
//

import Foundation
import Alamofire

enum StatusCode: Int {
    case success = 200
    case requiredParametersAreMissing = 400
    case invalidRequest = 401
    case accountRemoved = 403
    case accountNotActivated = 404
    case dataAlreadyExist = 409
    case serverError = 500
    case serverMaintenance = 503
    case serverNotResponsing = 1004
    case networkConnectionLost = 1005
    case requestTimedOut = 1001
}

enum Result<T, Failure> where Failure: Error {
    case success(value: T)
    case error(error: Failure)
}

class APIRequest {
    
    public static func request<T: Decodable> (_ urlConvertible: URLRequestConvertible, success: @escaping (T) -> Void, failed: (() -> Void)? = nil) {
        AF.request(urlConvertible).responseJSON { response in
            //Check the result from Alamofire's response and check if it's a success or a failure
                
            guard let res = response.response else {
                failed?()
                failure("Response not found!")
                return
            }
            
            
            let url = res.url?.absoluteString ?? ""
            let method = response.request?.httpMethod ?? ""
            let status = res.statusCode
            var errorMessage = ""
            var errorResponse = APIErrorType.noError
            // Will be refactoring
            switch response.result {
            case .success(let value):
                switch status {
                case StatusCode.success.rawValue:
                    print(value)
                    if let dict = value as? [String: Any], let T = try? T(from: dict) {
                        success(T)
                    } else {
                        errorResponse = .unknownError
                    }
                    
                case StatusCode.requiredParametersAreMissing.rawValue:
                    errorResponse = .requiredParametersAreMissing
                case StatusCode.serverError.rawValue:
                    errorResponse = .serverError
                case StatusCode.serverMaintenance.rawValue:
                    errorResponse = .serverMaintenance
                case StatusCode.invalidRequest.rawValue:
                    errorResponse = .invalidRequest
                case StatusCode.accountRemoved.rawValue:
                    errorResponse = .accountRemoved
                case StatusCode.dataAlreadyExist.rawValue:
                    errorResponse = .dataAlreadyExist
                default:
                    errorResponse = .unknownError
                }

                if let dict = value as? NSDictionary,
                   let message = dict["Error"] as? String {
                    errorMessage = message
                }
                
            case .failure(let error):
                failed?()
                if status == StatusCode.serverMaintenance.rawValue {
                    errorResponse = .serverMaintenance
                } else {
                    errorResponse = .serverNotResponsing
                }
            }

            if errorResponse != APIErrorType.noError || !errorMessage.isEmpty {
                let error = APIError(error: errorResponse,
                                     errorMessage: errorMessage,
                                     url: url,
                                     method: method,
                                     status: status)
                failure(error.errorMessage)
            }
            
            print("=================================================")
            print("API Response: \n \(response)")
            print("=================================================")
        }
    }
    
    static func failure(_ errorMessage: String) {
        AlertView.shared.presentSimpleAlert(title: "", message: errorMessage)
    }

}
