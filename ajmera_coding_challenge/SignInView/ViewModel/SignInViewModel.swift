//
//  SignInViewModel.swift
//  ajmera_coding_challenge
//
//  Created by Akash21Dubey on 25/01/25.
//

import Foundation
import SwiftUI

class SignInViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isSignInButtonEnabled: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false  // Added isLoading property
    @Published var navigateToDashboard: Bool = false  // Tracks successful sign-in
    
    private let emailRegEx = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    private let apiService = APIManager.shared  // The shared instance of APIService
    
    init() {
        // Initial validation for enabling the sign-in button
        updateButtonState()
    }
    
    // Email validation using regular expression
    private func isValidEmail(_ email: String) -> Bool {
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    // Password validation: non-empty check
    private func isValidPassword(_ password: String) -> Bool {
        return !password.isEmpty
    }
    
    // Enable or disable sign-in button based on validation
    func updateButtonState() {
        if isValidEmail(email) && isValidPassword(password) {
            isSignInButtonEnabled = true
            errorMessage = ""
        } else {
            isSignInButtonEnabled = false
        }
    }
    
    // Perform Sign In action
    func signIn() {
        // Perform the sign-in API call or logic here
        if !isValidEmail(email) {
            errorMessage = "Invalid email address."
        } else if !isValidPassword(password) {
            errorMessage = "Password cannot be empty."
        } else {
            callSignInApi()
        }
    }
    
    func callSignInApi() {
        // Create request data
        let requestData = SignInRequest(
            email: email,
            password: password
        )
        
        // Start loading
        //        isLoading = true
        
        // Call the API to signup
        apiService.signin(with: requestData) { result in
            DispatchQueue.main.async {
                //                self.isLoading = false
                switch result {
                case .success(result: let response):
                    //save user data to core Data
                    PersistenceController.shared.saveUser(
                        id: Int64(response.id) ?? 0,
                        email: response.email,
                        name: response.fullName,
                        dateOfBirth: response.dateOfBirth,
                        gender: response.gender
                    )
                    // Update isLoggedIn state
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    self.navigateToDashboard = true
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
