//
//  SignUpViewModelTests.swift
//  ajmera_coding_challengeTests
//
//  Created by Akash B Dubey on 26/01/25.
//

import XCTest
@testable import ajmera_coding_challenge // Replace with your app's module name

class SignUpViewModelTests: XCTestCase {
    
    var viewModel: SignUpViewModel!
    var mockAPIManager: MockAPIManager!
    
    override func setUp() {
        super.setUp()
        mockAPIManager = MockAPIManager()
        viewModel = SignUpViewModel(apiService: mockAPIManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPIManager = nil
        super.tearDown()
    }

    // Test: Check if form is valid when all fields are correctly filled
    func testValidForm() {
        viewModel.fullName = "John Doe"
        viewModel.email = "john.doe@example.com"
        viewModel.password = "Password123!"
        viewModel.confirmPassword = "Password123!"
        viewModel.dateOfBirth = Date(timeIntervalSince1970: -567648000) // Mock date of birth (18 years ago)
        viewModel.gender = "Male"
        
        viewModel.validateForm()
        
        XCTAssertTrue(viewModel.isFormValid)
        XCTAssertEqual(viewModel.errorMessage, "")
    }

    // Test: Check if form is invalid when required fields are empty
    func testFormInvalidWithEmptyFields() {
        viewModel.fullName = ""
        viewModel.email = ""
        viewModel.password = ""
        viewModel.confirmPassword = ""
        viewModel.dateOfBirth = Date(timeIntervalSince1970: -567648000)
        viewModel.gender = ""
        
        viewModel.validateForm()
        
        XCTAssertFalse(viewModel.isFormValid)
        XCTAssertEqual(viewModel.errorMessage, "All fields must be filled.")
    }

    // Test: Check if form is invalid with invalid email format
    func testInvalidEmailFormat() {
        viewModel.fullName = "John Doe"
        viewModel.email = "john.doe.com" // Invalid email format
        viewModel.password = "Password123!"
        viewModel.confirmPassword = "Password123!"
        viewModel.dateOfBirth = Date(timeIntervalSince1970: -567648000)
        viewModel.gender = "Male"
        
        viewModel.validateForm()
        
        XCTAssertFalse(viewModel.isFormValid)
        XCTAssertEqual(viewModel.errorMessage, "Please enter a valid email address.")
    }

    // Test: Check if form is invalid when passwords do not match
    func testPasswordMismatch() {
        viewModel.fullName = "John Doe"
        viewModel.email = "john.doe@example.com"
        viewModel.password = "Password123!"
        viewModel.confirmPassword = "Password456!"
        viewModel.dateOfBirth = Date(timeIntervalSince1970: -567648000)
        viewModel.gender = "Male"
        
        viewModel.validateForm()
        
        XCTAssertFalse(viewModel.isFormValid)
        XCTAssertEqual(viewModel.errorMessage, "Passwords do not match.")
    }

    // Test: Check if form is invalid when password does not meet criteria
    func testInvalidPassword() {
        viewModel.fullName = "John Doe"
        viewModel.email = "john.doe@example.com"
        viewModel.password = "password" // Invalid password (does not meet criteria)
        viewModel.confirmPassword = "password"
        viewModel.dateOfBirth = Date(timeIntervalSince1970: -567648000)
        viewModel.gender = "Male"
        
        viewModel.validateForm()
        
        XCTAssertFalse(viewModel.isFormValid)
        XCTAssertEqual(viewModel.errorMessage, "Password must be at least 6 characters long, include one uppercase letter, one number, and one special character.")
    }

    // Test: Check if form is invalid when user is underage
    func testUnderageUser() {
        viewModel.fullName = "John Doe"
        viewModel.email = "john.doe@example.com"
        viewModel.password = "Password123!"
        viewModel.confirmPassword = "Password123!"
        viewModel.dateOfBirth = Date() // Current date (underage)
        viewModel.gender = "Male"
        
        viewModel.validateForm()
        
        XCTAssertFalse(viewModel.isFormValid)
        XCTAssertEqual(viewModel.errorMessage, "You must be at least 18 years old.")
    }

    // Test: Check if signup successfully navigates to sign-in
    func testSignupSuccess() {
        viewModel.fullName = "John Doe"
        viewModel.email = "john.doe@example.com"
        viewModel.password = "Password123!"
        viewModel.confirmPassword = "Password123!"
        viewModel.dateOfBirth = Date(timeIntervalSince1970: -567648000) // 18 years ago
        viewModel.gender = "Male"
        
        // Trigger the mock signup API
        mockAPIManager.overrideSignupWithFailure = false
        
        // Call signup
        viewModel.signup()
        
        // Wait for async task to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.viewModel.navigateToSignIn)
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertEqual(self.viewModel.errorMessage, "")
        }
    }
}
