//
//  APIError.swift
//  ajmera_coding_challenge
//
//  Created by Akash21Dubey on 25/01/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case noData
    case serverError
    case decodingError
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .noData:
            return "No data received."
        case .serverError:
            return "Server error occurred."
        case .decodingError:
            return "Failed to decode response."
        }
    }
}
