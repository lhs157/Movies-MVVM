//
//  APIError.swift
//  MovieListMVVM
//
//  Created by mac on 11/02/2023.
//

import Foundation

enum APIErrorType {
    case noError
    case networkError
    case requiredParametersAreMissing
    case serverError
    case serverMaintenance
    case invalidRequest
    case accountRemoved
    case dataAlreadyExist
    case unknownError
    case serverNotResponsing
    case networkConnectionLost
    case requestTimedOut
}

enum Errors: Error {
    case emptyURLRequest
    case encodingProblem
}

struct APIError: Error {
    let error: APIErrorType
    let errorMessage: String
    let url: String
    let method: String
    let status: Int

    init(error: APIErrorType, errorMessage: String, url: String, method: String, status: Int) {
        self.error = error
        self.errorMessage = errorMessage
        self.url = url
        self.method = method
        self.status = status
    }
}
