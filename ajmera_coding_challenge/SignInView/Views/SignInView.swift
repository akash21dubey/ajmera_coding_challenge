//
//  SigninView.swift
//  ajmera_coding_challenge
//
//  Created by Akash B Dubey on 25/01/25.
//

import SwiftUI

struct SignInView: View {
    @StateObject private var viewModel = SignInViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {  // Stack the elements vertically
                Spacer()
                // Email TextField
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .onChange(of: viewModel.email) { _ in
                        viewModel.updateButtonState()
                    }
                    .padding(.horizontal)
                
                // Password SecureField
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .onChange(of: viewModel.password) { _ in
                        viewModel.updateButtonState()
                    }
                    .padding(.horizontal)
                
                // Sign-In Button
                Button(action: {
                    viewModel.signIn()
                }) {
                    Text("Sign In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.isSignInButtonEnabled ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .opacity(viewModel.isSignInButtonEnabled ? 1.0 : 0.5)
                }
                .disabled(!viewModel.isSignInButtonEnabled)
                .padding(.horizontal)
                
                // Error Message
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                Spacer()  // To push the link to the bottom
                
                // Sign-Up Link at the bottom
                HStack {
                    Text("Don't have an account?")
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign Up")
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.bottom, 20)  // Ensure it has some space from the bottom
            }
            .padding(.top, 40)  // Adjust top padding for better positioning
            .navigationTitle("Sign In")
            
            // Navigation to the dashboard
            .navigationDestination(isPresented: $viewModel.navigateToDashboard) {
                Dashboard()
            }
        }
    }
}

#Preview {
    SignInView()
}
