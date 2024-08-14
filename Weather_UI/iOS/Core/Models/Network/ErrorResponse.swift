//
//  ErrorResponse.swift
//  Color.Dev_UI
//
//  Created by Nikunj Singh on 02/02/23.
//

import Foundation

enum APIErrorResponse: Error {
    case networkError
    case apiError
    case decodingError
    case errorResponse
    
    func getError() -> String {
        switch self {
        case .networkError:
            return "Please check your internet connection."
        case .apiError:
            return "Something went wrong, please try again later"
        case .decodingError:
            return "Content Unavailable"
        case .errorResponse:
            return "Content Unavailable"
        }
    }
}

struct ErrorModel: Decodable {
    let code: Int
    let errorMessage: String
    let status: String
    
    private enum CodingKeys: String, CodingKey {
        case code = "code"
        case errorMessage = "error_msg"
        case status = "status"
    }
}
