//
//  AuthVM.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 3/5/26.
//
import SwiftUI
import AuthenticationServices

@MainActor
class AuthVM: ObservableObject {
    @AppStorage("auth") var auth = false
    @AppStorage("finishSignupInfo") var finishSignupInfo = false
    @AppStorage("signupInfoName") var signupInfoName = ""
    @AppStorage("accessToken") var accessToken = ""
    @AppStorage("userId") var userId = 0
    
    private let profileManager = ProfileManager.shared
    
    @Published var isLoading = false
    
    //Apple/Google/Email Signup/Login
    @Published var socialAuthFailed = false
    
    //Join as Creator
    @Published var inviteCode = ""          //-> pass to google/apple signup next step for creator
    @Published var codeAccepted = false
    @Published var codeMessage = ""
    
    //OTP Signup/Login
    @Published var phoneNumber = ""
    @Published var countryCode = 1
    @Published var otpCode = ""
    @Published var otpStep = 1
    
    //Additional Info
    @Published var addInfoStep = 1
    //Step 1
    @Published var name = ""
    @Published var country = ""
    @Published var email = ""
    @Published var birthday: Date = Date.now
    @Published var addedBirthday = false
    @Published var showAgeError = false
    
    //Step 1 (Basic user) or 2 (Creator)
    @Published var username = ""
    
    //Step 2
    @Published var isBrand = false
    @Published var displayName = ""
    @Published var updateFailure = false
    @Published var passButton = false
    
    //Login failed influencer value wrong
    @Published var needsToNav = false
    @Published var navBack = false
    
    //FUNCTIONS
    func verifyInviteCode() async throws {
        isLoading = true
        codeMessage = ""
        do {
            let response = try await APIManager().makePublicAPICallWithFullUrlGetStatus(url: "\(GlobalVars.APIbaseURL)auth/verify-invite-code/\(inviteCode)", httpMethod: "GET", requestData: nil)
            print(response.statusCode)
            print(response.response ?? "")
            switch response.statusCode {
            case 200:
                codeAccepted = true
            case 409:
                codeAccepted = false
                codeMessage = "Invite Code has already been used"
            default:
                codeAccepted = false
                codeMessage = "Invite Code is not valid"
            }
            isLoading = false
        } catch {
            print(error.localizedDescription)
            codeAccepted = false
            codeMessage = ""
            isLoading = false
        }
    }
    
    func socialLogin(token: String, name: String, email: String, platform: String, influencer: Bool, completion: @escaping (Int, String) -> Void) async throws {
        isLoading = true
        do {
            //influencer is true if they sign up with an invite code
            //in the backend we should set verified to true as well in this case
            let rqData = ["token": token, "full_name": name, "email": email, "platform": platform, "influencer": influencer, "invite_code": inviteCode] as [String : Any]
            let response = try await APIManager().makePublicAPICallWithFullUrlGetStatus(url: "\(GlobalVars.APIbaseURL)auth/social-login", httpMethod: "POST", requestData: rqData)
            switch response.statusCode {
            case 200: //log in
                try await loginUser(response: response.response ?? "")
                if !socialAuthFailed { completion(200, "") }
            case 201: //send to AddAdditionalInfoView to complete profile (name, birthday, email?, phone?)
                try await createUser(response: response.response ?? "")
                if !socialAuthFailed { completion(201, "") }
            case 400: //error
                //check if user is already influencer, or if tried to sign in as one and isnt, (error msg), if so retry sign in with influencer = !influencer
                completion(400, response.response ?? "")
//                print("Response: \(response.response ?? "")")
//                if let respData = (response.response ?? "").data(using: .utf8) {
//                    let decoded = try JSONDecoder().decode(JSONResponseAPI.self, from: respData)
//                    if ((decoded.message ?? "") == "User already registered as influencer.") || ((decoded.message ?? "") == "User already registered as Fan.") { //check what opposite error would be
//                        needsToNav = true
//                        try await socialLogin(token: token, name: name, email: email, platform: platform, influencer: !influencer) { resp in
//                            switch resp {
//                            case 200:
////                                self.auth = true
////                                self.navBack = true
//                                try await loginUser(response: response.response ?? "")
//                                if !socialAuthFailed { completion(200) }
//                            case 201:
////                                self.signupInfoName = name
////                                self.finishSignupInfo = true
////                                self.auth = true
////                                self.navBack = true
//                                try await createUser(response: response.response ?? "")
//                                if !socialAuthFailed { completion(201) }
//                            default:
////                                self.socialAuthFailed = true
////                                self.needsToNav = false
////                                self.navBack = false
//                                completion(400)
//                            }
//                        }
//                    } else {
//                        socialAuthFailed = true
//                        completion(400, "")
//                    }
//                } else {
//                    socialAuthFailed = true
//                    completion(400, "")
//                }
            case 500: //server error
                socialAuthFailed = true
                completion(400, "")
            default: //error
                socialAuthFailed = true
                completion(400, "")
            }
        } catch {
            print(error.localizedDescription)
            isLoading = false
            socialAuthFailed = true
        }
    }
    
    func loginOTP() async throws {
        isLoading = true
        do {
            //when is "influencer" true? Ask Alex
            let rqData = ["mobile": phoneNumber, "otp": Int(otpCode) ?? 0, "code": inviteCode] as [String : Any]
            let response = try await APIManager().makePublicAPICallWithFullUrlGetStatus(url: "\(GlobalVars.APIbaseURL)auth/authOTP", httpMethod: "POST", requestData: rqData)
            switch response.statusCode {
            case 200:
                //EITHER sent verif. code or logged in
                print("EITHER sent verif. code or should log in user")
            case 201:
                //send to AddAdditionalInfoView to complete profile (name, birthday, email?, phone?)
                print("created new user")
            case 400, 500: //error
                //error occurred with OTP login
                return
            default: //error
                //error occurred with OTP login
                return
            }
            isLoading = false
        } catch {
            print(error.localizedDescription)
            isLoading = false
        }
    }
    
    func updateProfile() async throws { //call from AuthAddInfoView to set initial profile fields
        //name, country, date of birth
        showAgeError = false
        isLoading = true
        
        if !check18YO() { showAgeError = true; return }
        
        var rqData: [String : Any] = [:]
        rqData["user_id"] = userId
        if name.trimmingCharacters(in: [" "]) != "" {
            rqData["fullname"] = name
        }
        if name.trimmingCharacters(in: [" "]) != "" {
            if name.trimmingCharacters(in: [" "]).contains(" ") {
                rqData["first_name"] = name.split(separator: " ")[0]
                rqData["last_name"] = name.split(separator: " ")[1]
            } else {
                rqData["first_name"] = name
                rqData["last_name"] = ""
            }
        }
        if country != "" {
            rqData["country"] = country
        }
        if addedBirthday {
           let bdayString = convertSwiftDateToDateStringYYYYMMDD(input: birthday)
            if bdayString != "" {
                rqData["dob"] = bdayString
            }
        }
        
        if displayName != "" { rqData["display_name"] = displayName }
        
        rqData["username"] = username
        
        rqData["is_brand"] = isBrand
        
        do {
            try await profileManager.updateProfile(uid: userId, requestData: rqData) { comp in
                print("update completion: \(comp)")
                if comp == 200 {
                    self.signupInfoName = ""
                    self.finishSignupInfo = false
                    self.isLoading = false
                } else {
                    self.updateFailure = true
                    self.isLoading = false
                }
            }
        } catch {
            print(error.localizedDescription)
            isLoading = false
            throw error
        }
    }
    
    func loginUser(response: String) async throws {
        print("logged in existing user")
        do {
            if !(try await saveUserInfo(response: response)) {
                socialAuthFailed = true
            }
        } catch {
            print(error.localizedDescription)
            socialAuthFailed = true
            isLoading = false
        }
    }
    
    func createUser(response: String) async throws {
        print("created new user")
        do {
            if !(try await saveUserInfo(response: response)) {
                socialAuthFailed = true
            }
        } catch {
            print(error.localizedDescription)
            socialAuthFailed = true
            isLoading = false
        }
    }
    
    func saveUserInfo(response: String) async throws -> Bool {
        @State var loadedProfile = true
        
        do {
            let decoded = try APIDecoders().decodeLoginResponse(jsonData: response)
            let user = decoded.data?.user
            let token = decoded.data?.token
//            
//            print("old userId: \(userId)")
//            userId = user?.id ?? 0
////            UserDefaults.standard.set(user?.id ?? 0, forKey: "userId")
//            print("new userId: \(userId)")
            
            if let user, let token = token {
                print("User id: \(user.id ?? 0)")
                userId = user.id ?? 0
                if let tok = token["access_token"] {
                    print("Token: \(tok)")
                    accessToken = tok
                } else {
                    print("Could not retrieve access token")
                    loadedProfile = false
                }
            } else {
                loadedProfile = false
            }
            
            //right now profileManager is not using new userId to load profile
            
            //TODO: we need to save the user to the ProfileManager profile
            try await profileManager.loadProfile(uid: userId) { comp in
                if comp != 200 {
                    print("failed to load profile")
                    loadedProfile = false
                }
            }
            
            return loadedProfile
        } catch {
            print(error.localizedDescription)
            socialAuthFailed = true
            isLoading = false
            return false
        }
    }
    
    func getAuthTokenApple(authResults: ASAuthorization) -> String {
        if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential {
            if let identityToken = appleIDCredential.identityToken,
               let tokenString = String(data: identityToken, encoding: .utf8) {
                return tokenString
            }

//            if let authorizationCode = appleIDCredential.authorizationCode,
//               let codeString = String(data: authorizationCode, encoding: .utf8) {
////                print("Authorization Code:")
////                print(codeString)
//                //todo -> dont think we need to send this?
//                return ""
//            }
        }
        return ""
    }
    
    func getAppleName(authResults: ASAuthorization) -> String {
        if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential {
            let firstName = appleIDCredential.fullName?.givenName ?? ""
            let lastName = appleIDCredential.fullName?.familyName ?? ""
            print("Apple name: \(firstName) \(lastName)")
            return "\(firstName) \(lastName)"
        }
        return ""
    }
    
    func getAppleEmail(authResults: ASAuthorization) -> String {
        if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential {
            let email = appleIDCredential.email ?? ""
            print("Apple email: \(email)")
            return email
        }
        return ""
    }
    
    func checkAddInfoButtonEnabled() -> Bool {
        //split up for step
        if addInfoStep == 1 {
            if (profileManager.profile?.influencer ?? false) {
                return name != "" && addedBirthday && check18YO() && country != ""
            } else {
                return name != "" && addedBirthday && check18YO() && country != "" && username != ""
            }
        } else {
            return username != ""
        }
    }
    
    
    func check18YO() -> Bool {
        return (Calendar.current.date(byAdding: .year, value: -18, to: Date.now) ?? Date.now) >= birthday
    }
}

struct OTPBody: Codable {
    let mobile: String
    let otp: Int
    let code: String
}

struct JSONResponseAPI: Codable {
    let success: Bool?
    let error: Bool?
    let message: String?
    let data: JSONValue?
    let status_code: Int?
}

