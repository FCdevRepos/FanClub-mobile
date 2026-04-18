//
//  VerifySocialMediaVM.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 3/27/26.
//
import SwiftUI
import AuthenticationServices

@MainActor
class VerifySocialMediaVM: NSObject, ObservableObject, ASWebAuthenticationPresentationContextProviding {
    
    private let profileManager = ProfileManager.shared
    
    
    @Published var isLoading = false
    @Published var step = 1
    
    @Published var acceptTerms = false
    
    let platforms = ["Instagram","TikTok","Twitter"]
    let images = ["instagram","tiktok","x"]
    
    @Published var connectedAccounts: [ConnectedSocialMediaAccountForVerify] = []
    //temp - probably wont use in this version
    
    @Published var showErrorAlert = false
    @Published var errorMsg = ""
    
    func getConnectedAccounts() async throws {
        isLoading = true
        do {
            let response = try await APIManager().makeAuthedAPICallWithFullUrlGetStatus(url: "\(GlobalVars.APIbaseURL)oauth/verification/connected-accounts/\(profileManager.profile?.id ?? 0)", httpMethod: "GET", requestData: nil)
            
            let acctResp = try APIDecoders().decodeSocialMediaAccountsVerifyResponse(jsonData: response.response ?? "")
            connectedAccounts = acctResp.data?.accounts ?? []
            isLoading = false
        } catch {
            print(error.localizedDescription)
            isLoading = false
            throw error
        }
    }
    
    func startVerification(platform: String) async throws {
        do {
            let response = try await APIManager().makeAuthedAPICallWithFullUrlGetStatus(url: "\(GlobalVars.APIbaseURL)oauth/verification/get-platform-oauth-url/\(platform)?user_id=\(profileManager.profile?.id ?? 0)", httpMethod: "GET", requestData: nil)
            
            if let respData = (response.response ?? "").data(using: .utf8) {
                let decoded = try JSONDecoder().decode(OAuthURLResponse.self, from: respData)
                
                if let oauthURL = decoded.data["url"] {
                    await UIApplication.shared.open(URL(string: oauthURL)!)
//                    let session = ASWebAuthenticationSession(
//                        url: URL(string: oauthURL)!,
//                        callbackURLScheme: "fanclubapp"
//                    ) { callbackURL, error in
//                        
//                        print("callback: \(callbackURL?.absoluteString ?? "")")
//                        print("error: \(error?.localizedDescription ?? "")")
//                        
//                        if ((callbackURL?.absoluteString.contains("error")) == true) {
//                            self.errorMsg = "Connect account failed"
//                            self.showErrorAlert = true
//                        } else {
//                            //refetch accounts
//                            Task {
//                                try await self.getConnectedAccounts()
//                            }
//                        }
//                        
//                    }
//                    
//                    session.presentationContextProvider = self
//                    session.prefersEphemeralWebBrowserSession = false
//                    session.start()
                }
            }
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    func submitApplication() async throws {
        isLoading = true
        do {
            //TODO -> does a POST need to contain requestData instead of /{user_id}?
            let response = try await APIManager().makeAuthedAPICallWithFullUrlGetStatus(url: "\(GlobalVars.APIbaseURL)oauth/verification/submit-verified-accounts/\(profileManager.profile?.id ?? 0)", httpMethod: "POST", requestData: nil)
            
            if response.statusCode == 200 {
                step += 1
            } else {
                errorMsg = "Submit accounts failed"
                showErrorAlert = true
            }
            isLoading = false
        } catch {
            print(error.localizedDescription)
            isLoading = false
            throw error
        }
    }
    
    func getAccountPlatformFromID(platformId: Int) -> String {
        if platformId == 2 { return "instagram" }
        else if platformId == 3 { return "twitter" }
        else if platformId == 6 { return "tiktok" }
        
        return ""
    }
    
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
}

struct OAuthURLResponse: Decodable {
    let data: [String: String]    // or `let data: DataPayload`
    let status_code: Int
    let success: Bool
    let message: String
    let error: Bool
}
