//
//  APIRouters.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 3/11/26.
//
import SwiftUI

internal enum APIRoutes: String {
    //AUTH
    case authOTP = "auth/authOTP"   //POST
    case signup = "auth/signup"   //POST
    case socialLogin = "auth/social-login" //POST
    case verifyInviteCode = "auth/verify-invite-code" //GET     //-> needs /{code} at end
    case logout = "auth/logout" //GET
    
    //USER
    case getUserById = "users/"  //GET   //-> needs /{userId} at end
    case updateUser = "users"    //POST  (route is literally just "fanclub.app/"
}

internal enum APIParmams {
    //AUTH
    case authOTP(mobile: String, otp: Int, code: String)
    case signup(mobile: String, otp: Int, code: String)
    case socialLogin(token: String, full_name: String, email: String, platform: String, influencer: Bool, invite_code: String)
    case verifyInviteCode(inviteCode: String)
    case logout(device_token: String)   //notification device token (FCM token)
    
    //USER
    case getUserById(user_id: Int, current_userID: Int) //-> turns into "/users/14?current_userID=1"
    case updateUser(user_id: Int)
}
