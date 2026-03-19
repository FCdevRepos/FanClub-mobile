//
//  APIRequestSchemas.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 3/13/26.
//
import SwiftUI

struct APIRequestSchemas {
    
    struct UpdateUserRequestSchema: Decodable {
        let user_id: Int?
        let fullname: String?
        let username: String?
        let first_name: String?
        let last_name: String?
        let email: String?
        let country: String?
        let password: String?
        let dob: String?    //date?
        let title: String?
        let bio: String?
        let account_type_id: Int?
        let mature_content: Bool?
        let display_name: String?
        let platform_user_popular_on: String?
        let followers_count_platform_user_popular_on: String?
        let handle_platform_user_popular_on: String?
        let other_works: String?
        let social_media_platform_to_verify: String?
    }
    
}
