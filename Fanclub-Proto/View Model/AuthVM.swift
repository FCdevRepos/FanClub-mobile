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
    @Published var name = ""
    @Published var country = ""
    @Published var email = ""
    @Published var birthday: Date = Date.now
    @Published var addedBirthday = false
    @Published var updateFailure = false
    @Published var passButton = false
    
    
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
    
    func socialLogin(token: String, name: String, email: String, platform: String, completion: @escaping (Int) -> Void)  async throws {
        isLoading = true
        do {
            //when is "influencer" true? Ask Alex
            let rqData = ["token": token, "full_name": name, "email": email, "platform": platform, "influencer": false, "invite_code": inviteCode] as [String : Any]
            let response = try await APIManager().makePublicAPICallWithFullUrlGetStatus(url: "\(GlobalVars.APIbaseURL)auth/social-login", httpMethod: "POST", requestData: rqData)
            switch response.statusCode {
            case 200: //log in
                try await loginUser(response: response.response ?? "")
                if !socialAuthFailed { completion(200) }
            case 201: //send to AddAdditionalInfoView to complete profile (name, birthday, email?, phone?)
                try await createUser(response: response.response ?? "")
                if !socialAuthFailed { completion(201) }
            case 400, 500: //error
                socialAuthFailed = true
                completion(400)
            default: //error
                socialAuthFailed = true
                completion(400)
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
        isLoading = true
        
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
        
        do {
            try await profileManager.updateProfile(requestData: rqData) { comp in
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
            
            //TODO: we need to save the user to the ProfileManager profile
            try await profileManager.loadProfile { comp in
                if comp != 200 {
                    print("failed to load profile")
                    loadedProfile = false
                }
            }
            
            if let user, let token = token {
                print("User id: \(user.id ?? 0)")
                userId = user.id ?? 0
                if let tok = token["access_token"] {
                    print("Token: \(tok)")
                    accessToken = tok
                    return loadedProfile    //return true normally but now return this
                } else {
                    print("Could not retrieve access token")
                    return false
                }
            } else {
                return false
            }
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
        return name != "" && addedBirthday && checkOfAge()
    }
    
    func checkOfAge() -> Bool {
        
        //TODO: if not 18, return false
        return true
    }
}

struct OTPBody: Codable {
    let mobile: String
    let otp: Int
    let code: String
}

