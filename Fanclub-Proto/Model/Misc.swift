//
//  Misc.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 4/8/26.
//
import SwiftUI

struct ConnectedSocialMediaAccountForVerify: Hashable, Codable {
    let user_id: Int?
    let social_media_platform_id: Int?
    let username: String?
    let profile_picture_url: String?
    let follows_count: Int?
    let platform_verified: Bool?
    let created_at: String? //date?
    let id: Int?
    let account_user_id: String?
    let name: String?
    let followers_count: Int?
    let media_count: Int?
    let submitted_account_status: String?
    let updated_at: String? //date?
}
