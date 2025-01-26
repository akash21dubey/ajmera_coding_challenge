//
//  MockAPIManager.swift
//  ajmera_coding_challengeTests
//
//  Created by Akash B Dubey on 26/01/25.
//

import Foundation
@testable import ajmera_coding_challenge

class MockAPIManager: APIServiceProtocol {
    var overrideSignupWithFailure = false
    var overrideSigninWithFailure = false
    
    init() {} // Explicit initializer for the mock manager
    
    // Mock signup method
    func signup(with data: SignUpRequest, completion: @escaping (Result<SignUpResponse, Error>) -> Void) {
        if overrideSignupWithFailure {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Simulated signup failure from mock API."])))
            return
        }
        
        // Simulate a successful signup response
        let mockResponse = SignUpResponse(
            fullName: data.fullName,
            email: data.email,
            password: data.password,
            dateOfBirth: data.dateOfBirth,
            gender: data.gender
        )
        completion(.success(mockResponse))
    }
    
    // Mock signin method
    func signin(with data: SignInRequest, completion: @escaping (Result<SignInResponse, Error>) -> Void) {
        if overrideSigninWithFailure {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Simulated signin failure from mock API."])))
            return
        }
        
        // Simulate a successful signin response
        let mockResponse = SignInResponse(
            id: "101",
            fullName: "mock full name",
            email: "mock@email.com",
            token: "mock_token",
            dateOfBirth: "01/01/2000",
            gender: "Male"
        )
        completion(.success(mockResponse))
    }
}

class MockKeychainHelper {
    var removeCalled = false
    var saveCalled = false
    var savedKey: String?
    var savedValue: String?
    
    // Mock save function
    static func save(key: String, value: String) -> Bool {
        MockKeychainHelper().saveCalled = true
        MockKeychainHelper().savedKey = key
        MockKeychainHelper().savedValue = value
        return true // Simulate a successful save
    }
    
    // Mock remove function
    static func remove(key: String) -> Bool {
        MockKeychainHelper().removeCalled = true
        return true // Simulate a successful remove
    }
}

class MockPersistenceController {
    static let shared = MockPersistenceController()
    
    // Store mock users
    var users: [User] = []
    
    // Save user data
    func saveUser(id: Int64, email: String, name: String, dateOfBirth: String, gender: String) {
        let mockUser = User()
        mockUser.id = id
        mockUser.email = email
        mockUser.fullName = name
        mockUser.dateOfBirth = dateOfBirth
        mockUser.gender = gender
        users.append(mockUser)
    }
    
    // Fetch user data
    func fetchUser() -> User? {
        return users.first
    }
    
    // Delete all users
    func deleteAllUsers() {
        users.removeAll()
    }
}

class User {
    var id: Int64 = 0
    var email: String = ""
    var fullName: String = ""
    var dateOfBirth: String = ""
    var gender: String = ""
}
