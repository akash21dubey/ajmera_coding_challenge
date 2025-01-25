//
//  SignUpModel.swift
//  ajmera_coding_challenge
//
//  Created by Akash B Dubey on 25/01/25.
//

import Foundation

// MARK: - SignupRequest
struct SignUpRequest: Codable {
    var fullName: String
    var email: String
    var password: String
    var dateOfBirth: Date
    var gender: String
}

// MARK: - SignupResponse
struct SignUpResponse: Codable {
    var fullName: String
    var email: String
    var password: String
    var dateOfBirth: Date
    var gender: String
}
