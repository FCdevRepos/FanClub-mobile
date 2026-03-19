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
                                try await vm.socialLogin(token: authorizationToken, name: name, email: email, platform: "apple") { responseCode in
                                    switch responseCode {
                                    case 200:
                                        auth = true
                                    case 201:
                                        signupInfoName = name //set name to pass into additional info view
                                        finishSignupInfo = true
                                        auth = true
                                    default: break
                                    }
//                                    if responseCode == 201 { //new user, add info
//                                        path.append(AppRoute.signupAddInfo(name: name, email: email, phone: "", birthday: ""))
//                                        //TODO: add phone (from VM), birthday (from google?)
//                                    }
                                    //else if its 200, it will be handled by changing auth to true? (we havent navigated anywhere from landing page so it should)
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
//                .overlay(
//                    Capsule()
//                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
//                )
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
                                try await vm.socialLogin(token: info[0], name: info[1], email: info[2], platform: "google") { responseCode in
                                    switch responseCode {
                                    case 200:
                                        auth = true
                                    case 201:
                                        signupInfoName = info[1]
                                        finishSignupInfo = true
                                        auth = true
                                    default: break
                                    }
//                                    if responseCode == 201 { //new user, add info
//                                        path.append(AppRoute.signupAddInfo(name: info[1], email: info[2], phone: "", birthday: ""))
//                                        //TODO: add phone (from VM), birthday (from google?)
//                                    }
//                                    //else if its 200, it will be handled by changing auth to true? (we havent navigated anywhere from landing page so it should)
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
