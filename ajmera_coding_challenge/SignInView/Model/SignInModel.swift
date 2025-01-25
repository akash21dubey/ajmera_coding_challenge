//
//  SignInModel.swift
//  ajmera_coding_challenge
//
//  Created by Akash21Dubey on 25/01/25.
//

import Foundation

// MARK: - SignupRequest
struct SignInRequest: Codable {
    var email: String
    var password: String
}

// MARK: - SignupResponse
struct SignInResponse: Codable {
    var id: String
    var fullName: String
    var email: String
    var token: String
    var dateOfBirth: String
    var gender: String
}
