//
//  SignupView.swift
//  ajmera_coding_challenge
//
//  Created by Akash21Dubey on 25/01/25.
//

import Foundation
import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    
    // State variables to toggle password visibility
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    
    var body: some View {
        Form {
            // Full Name
            TextField(AppConstants.fullNamePlaceHolder, text: $viewModel.fullName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.words)
                .onChange(of: viewModel.fullName) { _ in
                    viewModel.validateForm()
                }
            
            // Email
            TextField(AppConstants.emailPlaceHolder, text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .onChange(of: viewModel.email) { _ in
                    viewModel.validateForm()
                }
            
            // Password
            HStack {
                if isPasswordVisible {
                    TextField(AppConstants.passwordPlaceHolder, text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                } else {
                    SecureField(AppConstants.passwordPlaceHolder, text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                }
                
                // Eye icon to toggle visibility
                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                }
            }
            .onChange(of: viewModel.password) { _ in
                viewModel.validateForm()
            }
            
            // Confirm Password
            HStack {
                if isConfirmPasswordVisible {
                    TextField(AppConstants.confirmPasswordPlaceHolder, text: $viewModel.confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                } else {
                    SecureField(AppConstants.confirmPasswordPlaceHolder, text: $viewModel.confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                }
                
                // Eye icon to toggle visibility
                Button(action: {
                    isConfirmPasswordVisible.toggle()
                }) {
                    Image(systemName: isConfirmPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                }
            }
            .onChange(of: viewModel.confirmPassword) { _ in
                viewModel.validateForm()
            }
            
            // Date of Birth Picker
            DatePicker(AppConstants.dateOfBirthText, selection: $viewModel.dateOfBirth, in: ...Date().addingTimeInterval(viewModel.minimumAge), displayedComponents: .date)
                .onChange(of: viewModel.dateOfBirth) { _ in
                    viewModel.validateForm()
                }
            
            // Gender Picker
            Picker(AppConstants.genderText, selection: $viewModel.gender) {
                Text(AppConstants.selectGenderText).tag("")
                ForEach(viewModel.genders, id: \.self) { gender in
                    Text(gender).tag(gender)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .onChange(of: viewModel.gender) { _ in
                viewModel.validateForm()
            }
            
            // Sign-Up Button
            Button(action: {
                viewModel.signup()
            }) {
                Text(AppConstants.signUpText)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.isFormValid ? Color.blue : Color.gray) // Enable button only when form is valid
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(!viewModel.isFormValid) // Disable button if form is not valid
        }
        .navigationTitle(AppConstants.signUpNavigationBarTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Make sure the button is disabled when the screen is first loaded
            viewModel.validateForm()
        }
        .overlay(
            viewModel.isLoading ? ProgressView(AppConstants.signingUpText).progressViewStyle(CircularProgressViewStyle()) : nil
        )
        
        // Navigation to the login page
        .navigationDestination(isPresented: $viewModel.navigateToSignIn) {
            SignInView()
        }
    }
}

#Preview {
    SignUpView()
}
