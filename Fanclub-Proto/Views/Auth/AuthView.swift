//
//  LoginView.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 3/4/26.
//
import Foundation
import SwiftUI
import AuthenticationServices
import GoogleSignIn
import GoogleSignInSwift

struct AuthView: View {
    @AppStorage("auth") var auth = false
    @AppStorage("userId") var userId = 0
    @AppStorage("finishSignupInfo") var finishSignupInfo = false
    @AppStorage("signupInfoName") var signupInfoName = ""

//    @Binding var path: NavigationPath
    
    let PurpleButtonColor = Color(red: 144/255, green: 72/255, blue: 209/255)
    let GrayButtonColor = Color(red: 53/255, green: 53/255, blue: 53/255)
    
    @StateObject private var googleSignInVM = GoogleSignInViewModel()
    @StateObject var vm = AuthVM()
    
    var body: some View {
        ZStack {
            Color
                .black.opacity(0.92)
                .ignoresSafeArea()
            VStack {
                Image(.FANCLUB)
                    .resizable()
                    .frame(width: 280, height: 180)
                    .padding(.bottom)
                    .padding(.horizontal)
                    .padding(.top, 40)
                Spacer()
                
                //Apple Sign In Button
                SignInWithAppleButton(.continue) { request in
                    request.requestedScopes = [.email, .fullName]
                } onCompletion: { result in
                    switch result {
                    case .success(let authResults):
                        let authorizationToken = vm.getAuthTokenApple(authResults: authResults)
                        let name = vm.getAppleName(authResults: authResults).trimmingCharacters(in: [" "])
                        let email = vm.getAppleEmail(authResults: authResults).trimmingCharacters(in: [" "])
                        if authorizationToken != "" {
                            print("Apple Auth Success: ")
                            Task {
                                //MARK: if the user is already registered as an influencer this will fail and say they are already an influencer. two options:
                                    //retry login with influencer true, or save influencer as a user default and use that? only issue is if they have multiple accounts that may fail as well.
                                    //retry is probably better option
                                try await vm.socialLogin(token: authorizationToken, name: name, email: email, platform: "apple", influencer: false) { (code, response) in
                                    switch code {
                                    case 200:
                                        auth = true
                                    case 201:
                                        signupInfoName = name //set name to pass into additional info view
                                        finishSignupInfo = true
                                        auth = true
                                    case 400:
                                        //check if response is incorrect influencer type
                                        //try again
                                        Task {
                                            print("Response: \(response)")
                                            if let respData = (response).data(using: .utf8) {
                                                let decoded = try JSONDecoder().decode(JSONResponseAPI.self, from: respData)
                                                if ((decoded.message ?? "") == "User already registered as influencer.") || ((decoded.message ?? "") == "User already registered as Fan.") { //check what opposite error would be
                                                    try await vm.socialLogin(token: authorizationToken, name: name, email: email, platform: "apple", influencer: true) { c2, r2 in
                                                        switch c2 {
                                                        case 200:
                                                            auth = true
                                                        case 201:
                                                            signupInfoName = name
                                                            finishSignupInfo = true
                                                            auth = true
                                                        case 400:
                                                            vm.socialAuthFailed = true
                                                        default:
                                                            vm.socialAuthFailed = true
                                                        }
                                                    }
                                                } else {
                                                    vm.socialAuthFailed = true
                                                }
                                            } else {
                                                vm.socialAuthFailed = true
                                            }
                                        }
                                    default: break
                                    }
                                }
                            }
                        } else {
                            print("Apple Auth Success, but token is empty.")
                        }
                    case .failure(let error):
                        print("Apple Auth Failed: " + error.localizedDescription)
                        vm.socialAuthFailed = true
                    }
                }
                .signInWithAppleButtonStyle(.white)
                .frame(maxWidth: 280, minHeight: 50, maxHeight: 50)
                .clipShape(Capsule())
                .shadow(color: Color.black.opacity(0.35), radius: 8, x: 0, y: 6)
                .padding(.vertical, 8)
                .disabled(vm.isLoading)
//
                //Google Sign In Button
                Button {
                    googleSignInVM.signIn { result in
                        switch result {
                        case .success(let info):
                            print("Google Auth success")
                            Task {
                                try await vm.socialLogin(token: info[0], name: info[1], email: info[2], platform: "google", influencer: false) { (code, response) in
                                    switch code {
                                    case 200:
                                        auth = true
                                    case 201:
                                        signupInfoName = info[1]
                                        finishSignupInfo = true
                                        auth = true
                                    case 400:
                                        //check if response is incorrect influencer type
                                        //try again
                                        Task {
                                            print("Response: \(response)")
                                            if let respData = (response).data(using: .utf8) {
                                                let decoded = try JSONDecoder().decode(JSONResponseAPI.self, from: respData)
                                                if ((decoded.message ?? "") == "User already registered as influencer.") || ((decoded.message ?? "") == "User already registered as Fan.") { //check what opposite error would be
                                                    try await vm.socialLogin(token: info[0], name: info[1], email: info[2], platform: "google", influencer: true) { c2, r2 in
                                                        switch c2 {
                                                        case 200:
                                                            auth = true
                                                        case 201:
                                                            signupInfoName = info[1]
                                                            finishSignupInfo = true
                                                            auth = true
                                                        case 400:
                                                            vm.socialAuthFailed = true
                                                        default:
                                                            vm.socialAuthFailed = true
                                                        }
                                                    }
                                                } else {
                                                    vm.socialAuthFailed = true
                                                }
                                            } else {
                                                vm.socialAuthFailed = true
                                            }
                                        }
                                    default: break
                                    }
                                }
                            }
                        case .failure(let error):
                            print("Google Auth Failed: " + error.localizedDescription)
                            vm.socialAuthFailed = true
                        }
                    }
                } label: {
                    ZStack {
                        Capsule().fill(.white).shadow(radius: 3)
                        HStack {
                            Image(.googleIconBlack)
                                .resizable()
                                .frame(width: 20, height: 20)

                            Text("Continue with Google")
                                .font(.headline)
                                .foregroundColor(.black)
                        }.padding()
                    }
                    .frame(maxWidth: 280, minHeight: 50, maxHeight: 50)
                }
                .padding(.top, 5)
                .padding(.bottom, 10)
                .disabled(vm.isLoading)
                
                //Join as  a Creator Button
                NavigationLink { AuthCreatorSignupView() } label: {
//                Button { path.append(AppRoute.creatorSignup) } label: {
                    ZStack {
                        Capsule()
                            .fill(PurpleButtonColor)
                        Text("Join as a Creator")
                            .foregroundStyle(.white)
                            .font(.custom("Nunito-Bold", size: 18))
                            .padding()
                    }
                }
                .frame(maxWidth: 280, minHeight: 50, maxHeight: 50)
                .padding(.top, 10)
                .padding(.bottom, 60)
                
//                Text("or")
//                    .foregroundStyle(.gray)
//                    .opacity(0.5)
//                    .font(.custom("Nunito-Regular", size: 14))
//                    .padding(.top, 10)
//                NavigationLink { AuthOTPLoginView() } label: {
//                    Text("Continue with Mobile OTP")
//                        .foregroundStyle(.white)
//                        .font(.custom("Nunito-Regular", size: 16))
//                }.padding(.bottom, 60).padding(.top, 3)
            }
//            .onAppear {
//                for font in UIFont.familyNames {
//                    print("\(font)")
//                    for subfont in UIFont.fontNames(forFamilyName: font) {
//                        print("    \(subfont)")
//                    }
//                }
//            }
            .onAppear {
                print("user id: \(userId)")
            }
        }
        .alert("Authentication Failed", isPresented: $vm.socialAuthFailed) {
            Button("Ok", role: .cancel) {}
        } message: {
            Text("Please try again.")
        }
    }
}

//#Preview {
//    AuthView()
//}
