//
//  APIManager.swift
//  ajmera_coding_challenge
//
//  Created by Akash21Dubey on 25/01/25.
//

import Foundation

class APIManager: NSObject {
    static let shared = APIManager()
    
    private let baseURL = "https://6794d6aeaad755a134ea8dd5.mockapi.io/ajmera/example/api" // Replace with your base URL
    
    private override init() { }
    
    private lazy var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    // Function to handle API requests
    private func request<T: Codable>(_ endpoint: String, method: String, body: Codable?, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encode body if needed
        if let body = body {
            do {
                let encoder = JSONEncoder()
                request.httpBody = try encoder.encode(body)
            } catch {
                completion(.failure(error))
                return
            }
        }
        
        // Make the network request
        urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Signup request
    func signup(with data: SignUpRequest, completion: @escaping (Result<SignUpResponse, Error>) -> Void) {
        request("signup", method: "POST", body: data, completion: completion)
    }
    
    // Signin request
    func signin(with data: SignInRequest, completion: @escaping (Result<SignInResponse, Error>) -> Void) {
        request("signin", method: "POST", body: data, completion: completion)
    }
}

// SSL Bypass for development purposes
extension APIManager: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        // Use a credential to trust the server
        let credential = URLCredential(trust: serverTrust)
        completionHandler(.useCredential, credential)
    }
}
