//
//  KeychainHelper.swift
//  ajmera_coding_challenge
//
//  Created by Akash21Dubey on 25/01/25.
//

import Foundation
import Security

struct KeychainHelper {
    
    // Save data to Keychain
    static func save(key: String, value: String) -> Bool {
        guard let valueData = value.data(using: .utf8) else {
            print("Failed to convert value to Data")
            return false
        }
        
        // Define the query to search for an existing keychain item
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: valueData
        ]
        
        // Delete existing key if it exists
        SecItemDelete(query as CFDictionary)
        
        // Add new item to Keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        
        // Return true if successfully added, false otherwise
        return status == errSecSuccess
    }
    
    // Remove data from Keychain
    static func remove(key: String) -> Bool {
        // Define the query for finding the keychain item
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        // Delete the item
        let status = SecItemDelete(query as CFDictionary)
        
        return status == errSecSuccess
    }
}
