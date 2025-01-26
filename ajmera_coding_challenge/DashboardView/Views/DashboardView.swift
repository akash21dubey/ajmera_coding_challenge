//
//  Dashboard.swift
//  ajmera_coding_challenge
//
//  Created by Akash21Dubey on 25/01/25.
//

import Foundation
import SwiftUI

// Welcome/Dashboard Screen
struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel() // ViewModel instance
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Text("\(AppConstants.welcomeText) \(viewModel.user?.fullName ?? "")")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.signOut() // Call sign-out from ViewModel
                    }) {
                        Text(AppConstants.signOutText)
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}
