//
//  APIManager.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 3/11/26.
//
import SwiftUI

class APIManager {
    //TODO: create one where we dont need a url
    //  get the url from the endpoint, the query parameters from the routers parameters, etc.
    
    func makePublicAPICallWithFullUrlGetStatus(url: String, httpMethod: String, requestData: [String: Any]?) async throws -> (statusCode: Int, response: String?) {
        
        guard let url = URL(string: url) else {
            print("Invalid URL")
            throw NSError(domain: "APIError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.uppercased()
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let rqData = requestData {
            guard let jsonData = try? JSONSerialization.data(withJSONObject: rqData) else {
                print("Error encoding JSON")
                throw NSError(domain: "APIError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Error encoding JSON"])
            }
            request.httpBody = jsonData
        }

        print("Making public \(httpMethod) API request to endpoint \(url) with body \(requestData ?? [:])")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "APIError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response"])
        }

        let statusCode = httpResponse.statusCode
        let responseString = String(data: data, encoding: .utf8)

        print("Status code: \(statusCode)")
        print("Successful response: \(responseString ?? "nil")")

        return (statusCode, responseString)
    }
    
    func makeAuthedAPICallWithFullUrlGetStatus(url: String, httpMethod: String, requestData: [String: Any]?) async throws -> (statusCode: Int, response: String?) {
        //use access token as the HTTP header
        //old app code:
//        var header: HTTPHeaders {
//            if let accessToken = DBManager.accessUserDefaultsForKey(keyStr: "accessToken") as? String {
//                print("Bearer \(accessToken)")
//                return ["Authorization": "Bearer \(accessToken)"]
//            } else { return [:] }
//        }
        
        guard let url = URL(string: url) else {
            print("Invalid URL")
            throw NSError(domain: "APIError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.uppercased()
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            return (400, "Error calling API: No saved access token")
        }
        
        if let rqData = requestData {
            guard let jsonData = try? JSONSerialization.data(withJSONObject: rqData) else {
                print("Error encoding JSON")
                throw NSError(domain: "APIError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Error encoding JSON"])
            }
            request.httpBody = jsonData
        }

        print("Making public \(httpMethod) API request to endpoint \(url) with body \(requestData ?? [:])")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "APIError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response"])
        }

        let statusCode = httpResponse.statusCode
        let responseString = String(data: data, encoding: .utf8)

        print("Status code: \(statusCode)")
        print("Successful response: \(responseString ?? "nil")")

        return (statusCode, responseString)
    }
    
//    func makeAuthedAPICallWithFullUrlGetStatus(url: String, httpMethod: String, requestData: [String: Any]?) async throws -> (statusCode: Int, response: String?) {
//        guard let url = URL(string: url) else {
//            print("Invalid URL")
//            throw NSError(domain: "APIError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = httpMethod.uppercased()
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        var cookieString = ""
//        
//        if let sessionToken = UserDefaults.standard.string(forKey: "sessionToken") {
//            cookieString += "__Secure-next-auth.session-token=\(sessionToken); "
//        }
//
//        if let callbackUrl = UserDefaults.standard.string(forKey: "callbackUrl") {
//            cookieString += "__Secure-next-auth.callback-url=\(callbackUrl); "
//        }
//
//        if let csrfToken = UserDefaults.standard.string(forKey: "csrfToken") {
//            cookieString += "__Secure-next-auth.csrf-token=\(csrfToken); "
//        }
//        
//        request.addValue(cookieString, forHTTPHeaderField: "Cookie")
//        
//        if let rqData = requestData {
//            guard let jsonData = try? JSONSerialization.data(withJSONObject: rqData) else {
//                print("Error encoding JSON")
//                throw NSError(domain: "APIError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Error encoding JSON"])
//            }
//            request.httpBody = jsonData
//        }
//        
//        print("Making authenticated \(httpMethod) API request to endpoint \(url) with body \(requestData ?? [:])")
//
//        let (data, response) = try await URLSession.shared.data(for: request)
//
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw NSError(domain: "APIError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response"])
//        }
//
//        let statusCode = httpResponse.statusCode
//        let responseString = String(data: data, encoding: .utf8)
//
//        print("Status code: \(statusCode)")
//        print("Response: \(responseString ?? "nil")")
//
//        return (statusCode, responseString)
//    }

}
