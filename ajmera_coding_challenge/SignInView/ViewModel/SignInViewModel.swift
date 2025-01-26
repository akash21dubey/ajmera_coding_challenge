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
    
    let apiService: APIServiceProtocol // Use the protocol type here
    
    init(apiService: APIServiceProtocol = APIManager.shared) {
        self.apiService = apiService
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
            errorMessage = ValidationStrings.invalidEmailFormat
        } else if !isValidPassword(password) {
            errorMessage = ValidationStrings.passwordEmpty
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
        isLoading = true
        
        // Call the API to signup
        apiService.signin(with: requestData) { result in
            DispatchQueue.main.async {
                self.isLoading = false
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
                    // save token in keychain
                    _ = KeychainHelper.save(key: ConstantKeys.authToken, value: response.token)
                    // Update isLoggedIn state
                    UserDefaults.standard.set(true, forKey: ConstantKeys.isLoggedIn)
                    self.navigateToDashboard = true
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
