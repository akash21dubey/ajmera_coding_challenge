//
//  AppConstants.swift
//  ajmera_coding_challenge
//
//  Created by Akash21Dubey on 25/01/25.
//

import Foundation

struct ConstantKeys {
    static let isLoggedIn = "isLoggedIn"
    static let authToken = "authToken"
}
struct AppConstants {
    static let signOutText = "Sign Out"
    static let welcomeText = "Welcome,"
    static let emailPlaceHolder = "Email"
    static let passwordPlaceHolder = "Password"
    static let loginButtonText = "Sign In"
    static let dontHaveAccountText = "Don't have an account?"
    static let signUpText = "Sign Up"
    static let signingInText = "Signing In..."
    static let signInNavigationBarTitle = "Sign In"
    static let fullNamePlaceHolder = "Full Name"
    static let confirmPasswordPlaceHolder = "Confirm Password"
    static let dateOfBirthText = "Date of Birth"
    static let genderText = "Gender"
    static let selectGenderText = "Select Gender"
    static let signUpNavigationBarTitle = "Sign Up"
    static let signingUpText = "Signing Up..."
}

struct ValidationStrings {
    static let invalidEmailFormat = "Invalid email address."
    static let passwordEmpty = "Password cannot be empty."
    static let allFieldsEmpty = "All fields must be filled."
    static let enterValidEmail = "Please enter a valid email address."
    static let validPassword = "Password must be at least 6 characters long, include one uppercase letter, one number, and one special character."
    static let passwordDoesNotMatch = "Passwords do not match."
    static let mustBeAtLeast18YearsOld = "You must be at least 18 years old."
}

let emailRegEx = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
let passwordRegEx = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$&*])[A-Za-z0-9!@#$&*]{6,}$"
