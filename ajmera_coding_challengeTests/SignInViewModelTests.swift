//
//  SignInViewModelTests.swift
//  ajmera_coding_challengeTests
//
//  Created by Akash B Dubey on 26/01/25.
//

import XCTest
import Combine
@testable import ajmera_coding_challenge

class SignInViewModelTests: XCTestCase {

    var signInViewModel: SignInViewModel!
    var mockAPIManager: MockAPIManager!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockAPIManager = MockAPIManager()
        signInViewModel = SignInViewModel(apiService: mockAPIManager)
    }

    override func tearDown() {
        signInViewModel = nil
        mockAPIManager = nil
        cancellables = []
        super.tearDown()
    }

    func testInitialState() {
        XCTAssertFalse(signInViewModel.isSignInButtonEnabled)
        XCTAssertEqual(signInViewModel.errorMessage, "")
        XCTAssertFalse(signInViewModel.isLoading)
    }

    func testValidEmailAndPassword_EnableSignInButton() {
        signInViewModel.email = "test@example.com"
        signInViewModel.password = "ValidPassword123!"
        signInViewModel.updateButtonState()

        XCTAssertTrue(signInViewModel.isSignInButtonEnabled)
    }

    func testInvalidEmail_DisableSignInButton() {
        signInViewModel.email = "invalid-email"
        signInViewModel.password = "ValidPassword123!"
        signInViewModel.updateButtonState()

        XCTAssertFalse(signInViewModel.isSignInButtonEnabled)
    }

    func testInvalidPassword_DisableSignInButton() {
        signInViewModel.email = "test@example.com"
        signInViewModel.password = ""
        signInViewModel.updateButtonState()

        XCTAssertFalse(signInViewModel.isSignInButtonEnabled)
    }

    func testSignIn_WithValidCredentials_ShouldNavigateToDashboard() {
        signInViewModel.email = "test@example.com"
        signInViewModel.password = "ValidPassword123!"
        signInViewModel.signIn()

        // Simulate the API call response
        mockAPIManager.overrideSigninWithFailure = false

        // Expect navigateToDashboard to be true after successful sign-in
        let expectation = self.expectation(description: "Sign-in succeeded and navigate to dashboard")
        signInViewModel.$navigateToDashboard
            .dropFirst() // Drop the initial value
            .sink { value in
                if value {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 2, handler: nil)
    }

    func testErrorMessage_WhenEmailIsInvalid() {
        signInViewModel.email = "invalid-email"
        signInViewModel.password = "ValidPassword123!"
        signInViewModel.signIn()

        XCTAssertEqual(signInViewModel.errorMessage, "Invalid email address.")
    }

    func testErrorMessage_WhenPasswordIsEmpty() {
        signInViewModel.email = "test@example.com"
        signInViewModel.password = ""
        signInViewModel.signIn()

        XCTAssertEqual(signInViewModel.errorMessage, "Password cannot be empty.")
    }
}
