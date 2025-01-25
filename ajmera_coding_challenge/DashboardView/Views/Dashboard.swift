//
//  Dashboard.swift
//  ajmera_coding_challenge
//
//  Created by Akash B Dubey on 25/01/25.
//

import Foundation
import SwiftUI

// Welcome/Dashboard Screen
struct Dashboard: View {

    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome, akash")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Spacer()
            }
            .padding()
            .navigationBarBackButtonHidden(true)
        }
    }
}
