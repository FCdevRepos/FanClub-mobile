//
//  User.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 3/13/26.
//
import SwiftUI

struct User: Hashable, Codable {
    
    let id: Int?
    let fullname: String?
    let first_name: String?
    let last_name: String?
    let display_name: String?
    let email: String?
    let mobile: String?
    let username: String?
    let dob: String?        // Date?
    let bio: String?
    let country: String?
    let influencer: Bool?
    let profilePic: String?
    let coverpic: String?
    let govtID: String?
    let title: String?
//    let title: Int?
    let active: Bool?
    let mature_content: Bool?
    let verified: Bool?
    let verification_status: String?
    let verification_msg: String?
    let is_verification_requested: Bool?
    let is_hidden: Bool?
    let updated: Bool?
    let is_deleted: Bool?
    let is_brand: Bool?
    let notification: Bool?
    let invite_code_ctr: Int?
    let other_works: String?
    let verified_by_admin_id: Int?
    let account_type_id: Int?
    let represent_id: String?
    let stripe_connect_account_id: String?
    let stripe_customer_id: String?
    let zoom_id: String?
    let has_bank_details: Bool?
    let platform_user_popular_on: String?
    let followers_count_platform_user_popular_on: String?       // Int?
    let handle_platform_user_popular_on: String?
    let social_media_platform_to_verify: String?
    let created_at: String?     // Date?
}

struct SocialMediaUser: Hashable, Codable {
    let user_id: Int?
    let platform: String?
    let link: String?
    let id: Int?
}
