//
//  ProfileManager.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 3/13/26.
//
import SwiftUI

@MainActor
class ProfileManager: ObservableObject {
    static let shared = ProfileManager()
    
    @AppStorage("auth") var auth = false
    @AppStorage("finishSignupInfo") var finishSignupInfo = false    //this really only matters upon first signing up
    @AppStorage("accessToken") var accessToken = ""
    @AppStorage("userId") var userId = 0

    @Published var profile: User?
            
    let api: APIManager
    let routes: APIRoutes

    private init(api: APIManager = APIManager(), routes: APIRoutes = APIRoutes.verifyInviteCode) {
        self.api = api
        self.routes = routes
    }
    
    @MainActor
//    func loadInitialSession(completion: @escaping (Int) -> Void) async {// -> Bool {
//        do {
//            try await loadProfile { comp in
//                completion(comp)
//            }
//        } catch {
//            print("ProfileManager error: \(error.localizedDescription)")
//            
//        }
////        do {
////            try await checkVerified()
////            try await loadProfile()
////            try await getSession()
////            try await checkOrUpdateFirebaseNotificationFields()
////            await MainActor.run { self.sessionLoaded = true }
////            print("After loadSessionData: set ProfileManager sessionLoaded to true")
//////            return true
////        } catch {
////            print("Error loading session: \(error.localizedDescription)")
////            if error.localizedDescription != "cancelled" { sessionLoaded = true }
////        }
//    }

    func loadProfile(uid: Int, completion: @escaping (Int) -> Void) async throws {
        do {
            print("in load profile, parameter is \(uid)")
            if uid != 0 {
                let response = try await api.makePublicAPICallWithFullUrlGetStatus(url: "\(GlobalVars.APIbaseURL)users/\(uid)", httpMethod: "GET", requestData: nil)
                switch response.statusCode {
                case 200:
                    let user = try APIDecoders().decodeUserResponse(jsonData: response.response ?? "")
                    profile = user.data?.user
//                    userId = user.data?.user?.id ?? 0
                    completion(200)
                default:
                    print("Error loading profile")
                    completion(400)
                }
            } else {
                print("could not load user, no user id saved")
                completion(400)
            }
        } catch {
            print("Failed to load profile: \(error.localizedDescription)")
            completion(400)
            return
        }
    }
    
    func updateProfile(uid: Int, requestData: [String : Any], completion: @escaping (Int) -> Void) async throws {
        do {
            if uid != 0 {
                let response = try await api.makeAuthedAPICallWithFullUrlGetStatus(url: "\(GlobalVars.APIbaseURL)users/", httpMethod: "PATCH", requestData: requestData)
                switch response.statusCode {
                case 200:
                    print(response)
                    try await loadProfile(uid: uid) { loadComp in print(loadComp) }
                    completion(200)
                default:
                    print("Error updating profile")
                    completion(400)
                }
            } else {
                print("could not load user, no user id saved")
                completion(400)
            }
        } catch {
            print("Failed to load profile: \(error.localizedDescription)")
            completion(400)
            return
        }
    }
    
    func checkOrUpdateFirebaseNotificationFields() async throws {
//        if let prof = profile {
//            if prof.id != 0 {
//                var rqBody: [String : Any] = ["id":profile?.id ?? 0]
//                do {
//                    if ((profile?.allowNotifications ?? false) != UserDefaults.standard.bool(forKey: "allowNotifications")) || ((profile?.fcmKey ?? "") != UserDefaults.standard.string(forKey: "fcmKey")) {
//                        rqBody["fcmKey"] = UserDefaults.standard.string(forKey: "fcmKey")
//                        rqBody["allowNotifications"] = UserDefaults.standard.bool(forKey: "allowNotifications")
//                        let rqShell = ["0":["json":rqBody]]
//                        let _ = try await api.makeAuthedAPICallWithFullUrl(url: "\(serverURL)/api/trpc/viewer/updateDeviceFCMKey?batch=1", httpMethod: "POST", requestData: rqShell)
//                        try await loadProfile()
//                    }
//                } catch {
//                    print(error.localizedDescription)
//                    throw error
//                }
//            }
//        }
    }

    func clearProfile() {
        self.profile = nil
    }
    
    func logout() {
        print("logging user out")
        UserDefaults.standard.set(false, forKey: "auth")
        UserDefaults.standard.set("", forKey: "accessToken")
        UserDefaults.standard.set(0, forKey: "userId")
        UserDefaults.standard.set(false, forKey: "finishSignupInfo")
        
//        let response = APIManager().makeAuthedAPICallWithFullUrlGetStatus(url: APIRoutes.logout.rawValue, httpMethod: "GET", requestData: nil)
    }
}

