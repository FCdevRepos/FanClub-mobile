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
//            {"user": jsonable_encoder(db_user), "fanFollowers": count, "totalFollowers": FollowerCount, "following": followingCount, "socialMedia": jsonable_encoder(socialMedia), "posts": jsonable_encoder(posts), "currentUserFollowing": followingStatus, "dm_price": dm_price, "is_subscribed": is_subscribed, "is_subscription_plan": is_subscription_plan, "is_unsubscribe_triggered": is_unsubscribe_triggered} OR
//            {"user": jsonable_encoder(db_user), "fanFollowers": count, "totalFollowers": FollowerCount, "following": followingCount, "socialMedia": jsonable_encoder(socialMedia), "posts": posts} OR
//            {"user": jsonable_encoder(db_user), "following": followingCount}
            let user: User?
            let fanFollowers: Int?
            let totalFollowers: Int?
            let following: Int?
            let socialMedia: [SocialMediaResponseGetUserSchema]?
            let posts: [JSONValue]?
            let currentUserFollowing: Bool?
            let dm_price: Bool?
            let is_subscribed: Bool?
            let is_subscription_plan: Bool?
            let is_unsubscribe_triggered: Bool?
        }
    }
    
    struct SocialMediaResponseGetUserSchema: Decodable {
        let success: Bool?
        let error: Bool?
        let message: String?
        let data: [SocialMediaResponseGetUserDataSchema]?
        
        struct SocialMediaResponseGetUserDataSchema: Decodable {
            let user_id: Int?
            let platform: String?
            let link: String?
            let id: Int?
        }
    }
    
    struct SocialMediAccountsVerifySchema: Decodable {
        let success: Bool?
        let error: Bool?
        let message: String?
        let data: SocialMediAccountsVerifyDataSchema?
        
        struct SocialMediAccountsVerifyDataSchema: Decodable {
            let accounts: [ConnectedSocialMediaAccountForVerify]?
        }
    }
}
