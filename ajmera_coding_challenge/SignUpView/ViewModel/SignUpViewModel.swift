//
//  SignupViewModel.swift
//  ajmera_coding_challenge
//
//  Created by Akash21Dubey on 25/01/25.
//

import Foundation

class SignUpViewModel: ObservableObject {
    @Published var fullName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var dateOfBirth = Date()
    @Published var gender = ""
    
    @Published var isLoading: Bool = false  // Added isLoading property
    @Published var errorMessage = ""
    @Published var isFormValid = false // This is used to enable/disable the button
    @Published var navigateToSignIn: Bool = false  // Tracks successful sign-up
    
    let genders = ["Male", "Female", "Other"]
    let minimumAge: TimeInterval = -18 * 365 * 24 * 60 * 60 // 18 years ago from current time
    let apiService: APIServiceProtocol // Use the protocol type here
    
    init(apiService: APIServiceProtocol = APIManager.shared) {
        self.apiService = apiService
    }
    
    // MARK: - Validation Logic
    func validateForm() {
        if fullName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty || gender.isEmpty {
            isFormValid = false
            errorMessage = ValidationStrings.allFieldsEmpty
            return
        }
        
        // Email validation
        guard isValidEmail(email) else {
            isFormValid = false
            errorMessage = ValidationStrings.enterValidEmail
            return
        }
        
        // Password validation
        guard isValidPassword(password) else {
            isFormValid = false
            errorMessage = ValidationStrings.validPassword
            return
        }
        
        // Password confirmation
        guard password == confirmPassword else {
            isFormValid = false
            errorMessage = ValidationStrings.passwordDoesNotMatch
            return
        }
        
        // Age validation
        let today = Date()
        guard dateOfBirth <= today.addingTimeInterval(minimumAge) else {
            isFormValid = false
            errorMessage = ValidationStrings.mustBeAtLeast18YearsOld
            return
        }
        
        // If all checks pass
        isFormValid = true
        errorMessage = ""
    }
    
    // Helper methods for validation
    private func isValidEmail(_ email: String) -> Bool {
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
    
    func signup() {
        // Create request data
        let requestData = SignUpRequest(
            fullName: fullName,
            email: email,
            password: password,
            dateOfBirth: dateOfBirth,
            gender: gender
        )
        
        // Start loading
        isLoading = true
        
        // Call the API to signup
        apiService.signup(with: requestData) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.navigateToSignIn = true
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
