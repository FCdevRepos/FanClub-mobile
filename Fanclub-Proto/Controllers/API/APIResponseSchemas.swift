//
//  APIResponseSchemas.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 3/13/26.
//
import SwiftUI

struct APIResponseSchemas {
    
    struct LoginResponseSchema: Decodable {
        let success: Bool?
        let error: Bool?
        let message: String?
        let data: LoginResponseDataSchema?
        let status_code: Int?
        
        struct LoginResponseDataSchema: Decodable {
            let user: User?
            let token: [String : String]    // { "access_token" : "..." }
        }
    }
    
    
    
    struct UserResponseSchema: Decodable {
        let success: Bool?
        let error: Bool?
        let message: String?
        let data: UserResponseDataSchema?
        
        struct UserResponseDataSchema: Decodable {
            let user: User?
            let following: Int?
        }
    }
}
