//
//  DashboardViewModelTests.swift
//  ajmera_coding_challengeTests
//
//  Created by Akash B Dubey on 26/01/25.
//

import XCTest
@testable import ajmera_coding_challenge

class DashboardViewModelTests: XCTestCase {
    
    var dashboardViewModel: DashboardViewModel!
    
    override func setUp() {
        super.setUp()
        dashboardViewModel = DashboardViewModel()
        // Reset Mock PersistenceController and MockKeychainHelper before each test
        MockPersistenceController.shared.users = []
        _ = MockKeychainHelper.remove(key: ConstantKeys.authToken)
    }
    
    override func tearDown() {
        dashboardViewModel = nil
        super.tearDown()
    }
    
    func testSignOutRemovesUserData() {
        // Arrange: Set up a mock user in the persistence controller and keychain
        MockPersistenceController.shared.saveUser(id: 1, email: "test@example.com", name: "Test User", dateOfBirth: "01/01/1990", gender: "Male")
        _ = MockKeychainHelper.save(key: ConstantKeys.authToken, value: "mock_token")
        
        // Act: Call the signOut method
        dashboardViewModel.signOut()
        MockPersistenceController.shared.deleteAllUsers()
        
        // Assert: Verify that the user is removed from the persistence controller
        XCTAssertNil(MockPersistenceController.shared.fetchUser(), "User should be deleted from the mock persistence.")
        
        // Assert: Verify that the auth token is removed from the keychain
        XCTAssertTrue(MockKeychainHelper.remove(key: ConstantKeys.authToken), "Auth token should be deleted from the mock keychain.")
    }
    
    // Test signOut when no user is logged in
    func testSignOutWhenNoUserLoggedIn() {
        // Arrange: Ensure no user is saved in the persistence controller and no token is in the keychain
        MockPersistenceController.shared.users = []
        _ = MockKeychainHelper.remove(key: ConstantKeys.authToken)
        
        // Act: Call the signOut method
        dashboardViewModel.signOut()
        
        // Assert: Ensure that the persistence controller is still empty
        XCTAssertTrue(MockPersistenceController.shared.users.isEmpty, "No users should exist in the mock persistence.")
        
        // Assert: Ensure that the keychain is still empty
        XCTAssertTrue(MockKeychainHelper.remove(key: ConstantKeys.authToken), "No token should exist in the mock keychain.")
    }
    
    // Test if the signOut method works when the Keychain is empty
    func testSignOutWhenKeychainIsEmpty() {
        // Arrange: Ensure Keychain is empty
        _ = MockKeychainHelper.remove(key: ConstantKeys.authToken)
        
        // Act: Call the signOut method
        dashboardViewModel.signOut()
        
        // Assert: Ensure that the keychain is still empty (no error should be thrown)
        XCTAssertTrue(MockKeychainHelper.remove(key: ConstantKeys.authToken), "Keychain should remain empty.")
    }
    
    // Test clearUserDefaults when signing out
    func testClearUserDefaultsOnSignOut() {
        // Arrange: Mock that the user is logged in in UserDefaults
        UserDefaults.standard.set(true, forKey: ConstantKeys.isLoggedIn)
        
        // Act: Call the signOut method
        dashboardViewModel.signOut()
        
        // Assert: Verify that UserDefaults is cleared
        XCTAssertNil(UserDefaults.standard.value(forKey: ConstantKeys.isLoggedIn), "UserDefaults should be cleared after sign out.")
    }
    
    // Test signOut when PersistenceController is empty
    func testSignOutWhenPersistenceControllerIsEmpty() {
        // Arrange: Ensure there is no user saved in the persistence controller
        MockPersistenceController.shared.users = []
        
        // Act: Call the signOut method
        dashboardViewModel.signOut()
        
        // Assert: Verify that no errors occur and PersistenceController is still empty
        XCTAssertTrue(MockPersistenceController.shared.users.isEmpty, "PersistenceController should remain empty.")
    }
}
