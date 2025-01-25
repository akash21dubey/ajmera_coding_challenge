//
//  SignupViewModel.swift
//  ajmera_coding_challenge
//
//  Created by Akash B Dubey on 25/01/25.
//

import Foundation

class SignUpViewModel: ObservableObject {
    @Published var fullName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var dateOfBirth = Date()
    @Published var gender = ""
    
    @Published var errorMessage = ""
    @Published var isFormValid = false // This is used to enable/disable the button
    
    let genders = ["Male", "Female", "Other"]
    let minimumAge: TimeInterval = -18 * 365 * 24 * 60 * 60 // 18 years ago from current time
    private let apiService = APIManager.shared  // The shared instance of APIService
    
    // MARK: - Validation Logic
    func validateForm() {
        if fullName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty || gender.isEmpty {
            isFormValid = false
            errorMessage = "All fields must be filled."
            return
        }
        
        // Email validation
        guard isValidEmail(email) else {
            isFormValid = false
            errorMessage = "Please enter a valid email address."
            return
        }
        
        // Password validation
        guard isValidPassword(password) else {
            isFormValid = false
            errorMessage = "Password must be at least 6 characters long, include one uppercase letter, one number, and one special character."
            return
        }
        
        // Password confirmation
        guard password == confirmPassword else {
            isFormValid = false
            errorMessage = "Passwords do not match."
            return
        }
        
        // Age validation
        let today = Date()
        guard dateOfBirth <= today.addingTimeInterval(minimumAge) else {
            isFormValid = false
            errorMessage = "You must be at least 18 years old."
            return
        }
        
        // If all checks pass
        isFormValid = true
        errorMessage = ""
    }
    
    // Helper methods for validation
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$&*])[A-Za-z0-9!@#$&*]{6,}$"
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
//        isLoading = true
        
        // Call the API to signup
        apiService.signup(with: requestData) { result in
            DispatchQueue.main.async {
//                self.isLoading = false
                switch result {
                case .success(let response):
                    print(response)
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
