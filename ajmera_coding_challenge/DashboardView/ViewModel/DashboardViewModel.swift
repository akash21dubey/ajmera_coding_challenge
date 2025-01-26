//
//  DashboardViewModel.swift
//  ajmera_coding_challenge
//
//  Created by Akash B Dubey on 25/01/25.
//

import Foundation
import SwiftUI
import CoreData

class DashboardViewModel: ObservableObject {
    
    @Published var user: User?
    
    init() {
        fetchUser()
    }
    
    private func fetchUser() {
        self.user = PersistenceController.shared.fetchUser()
    }
    
    // Sign out function
    func signOut() {
        clearUserDefaults()
        clearKeychain()
        clearCoreData()
    }
    
    private func clearUserDefaults() {
        UserDefaults.standard.removeObject(forKey: ConstantKeys.isLoggedIn)
    }
    
    private func clearKeychain() {
        _ = KeychainHelper.remove(key: ConstantKeys.authToken) // Make sure KeychainHelper is correctly implemented
    }
    
    private func clearCoreData() {
        PersistenceController.shared.deleteAllUsers()
    }
}
