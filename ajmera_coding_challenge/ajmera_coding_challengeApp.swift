//
//  ajmera_coding_challengeApp.swift
//  ajmera_coding_challenge
//
//  Created by Akash B Dubey on 25/01/25.
//

import SwiftUI

@main
struct ajmera_coding_challengeApp: App {
    
    @AppStorage(ConstantKeys.isLoggedIn) private var isLoggedIn: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                DashboardView()
            } else {
                SignInView()
            }
        }
    }
}
