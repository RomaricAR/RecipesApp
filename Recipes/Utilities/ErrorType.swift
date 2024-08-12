//
//  ErrorType.swift
//  Recipes
//
//  Created by Romaric Allahramadji on 8/12/24.
//

import Foundation

enum ErrorType: LocalizedError {
    case networkError
    case parsingError
    case validationError
    case unknownError

    var errorDescription: String? {
        switch self {
        case .networkError:
            return "A network error occurred. Please check your connection and try again."
        case .parsingError:
            return "There was an error processing the data. Please try again later."
        case .validationError:
            return "Received unexpected or incomplete data. Please try again later."
        case .unknownError:
            return "An unknown error occurred. Please try again."
        }
    }
}
