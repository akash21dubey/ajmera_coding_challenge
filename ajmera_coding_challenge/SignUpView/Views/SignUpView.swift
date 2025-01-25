//
//  SignupView.swift
//  ajmera_coding_challenge
//
//  Created by Akash B Dubey on 25/01/25.
//

import Foundation
import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    
    var body: some View {
        Form {
            // Full Name
            TextField("Full Name", text: $viewModel.fullName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.words)
                .onChange(of: viewModel.fullName) { _ in
                    viewModel.validateForm()
                }
            
            // Email
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .onChange(of: viewModel.email) { _ in
                    viewModel.validateForm()
                }
            
            
            // Password
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .onChange(of: viewModel.password) { _ in
                    viewModel.validateForm()
                }
            
            // Confirm Password
            SecureField("Confirm Password", text: $viewModel.confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .onChange(of: viewModel.confirmPassword) { _ in
                    viewModel.validateForm()
                }
            
            // Date of Birth Picker
            DatePicker("Date of Birth", selection: $viewModel.dateOfBirth, in: ...Date().addingTimeInterval(viewModel.minimumAge), displayedComponents: .date)
                .onChange(of: viewModel.dateOfBirth) { _ in
                    viewModel.validateForm()
                }
            
            // Gender Picker
            Picker("Gender", selection: $viewModel.gender) {
                Text("Select Gender").tag("")
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
                Text("Sign Up")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.isFormValid ? Color.blue : Color.gray) // Enable button only when form is valid
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(!viewModel.isFormValid) // Disable button if form is not valid
            
            // Error message
            if !viewModel.isFormValid {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .navigationTitle("Sign Up")
        .onAppear {
            // Make sure the button is disabled when the screen is first loaded
            viewModel.validateForm()
        }
    }
}

#Preview {
    SignUpView()
}
