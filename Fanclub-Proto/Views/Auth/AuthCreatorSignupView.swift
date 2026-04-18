//
//  AuthCreatorVerifyInviteCodeView.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 3/10/26.
//
import SwiftUI
import AuthenticationServices
import GoogleSignIn
import GoogleSignInSwift

struct AuthCreatorSignupView: View {
    @AppStorage("auth") var auth = false
    @AppStorage("finishSignupInfo") var finishSignupInfo = false
    @AppStorage("signupInfoName") var signupInfoName = ""
    
//    @Binding var path: NavigationPath
    
    @Environment(\.dismiss) var dismiss
    @StateObject var vm = AuthVM()
    
    @StateObject private var googleSignInVM = GoogleSignInViewModel()
    
    var body: some View {
        ZStack {
            Color
                .black.opacity(0.92)
                .ignoresSafeArea()
            VStack {
                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.white)
                            .font(.title)
                    }
                    Spacer()
                }.padding()
                if vm.codeAccepted {
                    Text("Continue Sign Up with one of the following platforms")
                        .foregroundStyle(.white)
                        .font(.custom("Nunito-Medium", size: 24))
                        .multilineTextAlignment(.center)
                        .padding(.top, 30)
                        .padding(.bottom)
                        .padding(.horizontal, 30)
                    
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
                                print("Apple Auth Success")
                                Task {
                                    try await vm.socialLogin(token: authorizationToken, name: name, email: email, platform: "apple", influencer: true) { (code, response) in
                                        switch code {
                                        case 200:
                                            auth = true
                                            dismiss()
                                        case 201:
                                            signupInfoName = name
                                            finishSignupInfo = true
                                            auth = true
                                            dismiss()
                                        case 400:
                                            //check if response is incorrect influencer type
                                            //try again
                                            Task {
                                                print("Response: \(response)")
                                                if let respData = (response).data(using: .utf8) {
                                                    let decoded = try JSONDecoder().decode(JSONResponseAPI.self, from: respData)
                                                    if ((decoded.message ?? "") == "User already registered as influencer.") || ((decoded.message ?? "") == "User already registered as Fan.") { //check what opposite error would be
                                                        try await vm.socialLogin(token: authorizationToken, name: name, email: email, platform: "apple", influencer: false) { c2, r2 in
                                                            switch c2 {
                                                            case 200:
                                                                auth = true
                                                                dismiss()
                                                            case 201:
                                                                signupInfoName = name
                                                                finishSignupInfo = true
                                                                auth = true
                                                                dismiss()
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
                            print("Auth Failed: " + error.localizedDescription)
                            vm.socialAuthFailed = true
                        }
                    }
                    .signInWithAppleButtonStyle(.white)
                    .frame(maxWidth: 280, minHeight: 50, maxHeight: 50)
                    .clipShape(Capsule())
                    .shadow(color: Color.black.opacity(0.35), radius: 8, x: 0, y: 6)
                    .padding(.vertical, 8)
                    .padding(.top)
                    .disabled(vm.isLoading)
//                    .onTapGesture {
//                        print("Tapped apple sign in")
//                    }
                    
                    //Google Sign In Button
                    Button {
                        googleSignInVM.signIn { result in
                            switch result {
                            case .success(let info):
                                print("Google Auth success")
                                Task {
                                    try await vm.socialLogin(token: info[0], name: info[1], email: info[2], platform: "google", influencer: true) { (code, response) in
                                        switch code {
                                        case 200:
                                            auth = true
                                            dismiss()
                                        case 201:
                                            signupInfoName = info[1] //set name to pass into additional info view
                                            finishSignupInfo = true
                                            auth = true
                                            dismiss()
                                        case 400:
                                            //check if response is incorrect influencer type
                                            //try again
                                            Task {
                                                print("Response: \(response)")
                                                if let respData = (response).data(using: .utf8) {
                                                    let decoded = try JSONDecoder().decode(JSONResponseAPI.self, from: respData)
                                                    if ((decoded.message ?? "") == "User already registered as influencer.") || ((decoded.message ?? "") == "User already registered as Fan.") { //check what opposite error would be
                                                        try await vm.socialLogin(token: info[0], name: info[1], email: info[2], platform: "google", influencer: false) { c2, r2 in
                                                            switch c2 {
                                                            case 200:
                                                                auth = true
                                                                dismiss()
                                                            case 201:
                                                                signupInfoName = info[1]
                                                                finishSignupInfo = true
                                                                auth = true
                                                                dismiss()
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
                    Spacer()
                } else {
                    Text("Enter a valid Invite Code to signup as a Creator")
                        .foregroundStyle(.white)
                        .font(.custom("Nunito-Medium", size: 24))
                        .multilineTextAlignment(.center)
                        .padding(.top, 30)
                        .padding(.bottom)
                        .padding(.horizontal, 30)
                    if vm.inviteCode != "" {
                        HStack {
                            Text("Invite Code").foregroundStyle(.white.opacity(0.7)).font(.custom("Nunito-Regular", size: 18))
                            Spacer()
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.horizontal, 30)
                        .padding(.top)
                        .padding(.bottom, 5)
                    }
                    TextField("", text: $vm.inviteCode, prompt: Text("Invite Code").foregroundStyle(.gray.opacity(0.5))).font(.custom("Montserrat-Regular", size: 20))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 30)
                        .padding(.top, vm.inviteCode == "" ? 20 : 5)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.gray)
                        .padding(.bottom)
                        .padding(.horizontal, 30)
                        .padding(.top, 4)
                    if vm.codeMessage != "" {
                        Text(vm.codeMessage)
                            .foregroundStyle(.red)
                            .font(.custom("Nunito-Regular", size: 18))
                            .padding(.horizontal)
                    }
                    Button {
                        hideKeyboard()
                        Task {
                            try await vm.verifyInviteCode()
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(vm.inviteCode == "" ? GlobalVars.GrayButtonColor : GlobalVars.PurpleButtonColor)
                            if vm.isLoading {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .tint(.white)
                                    .padding()
                            } else {
                                Text("Verify")
                                    .font(.custom("Nunito-Medium", size: 20))
                                    .padding()
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                    .fixedSize()
                    .disabled(vm.inviteCode == "")
                    .padding()
                    Spacer()
                }
            }
            .ignoresSafeArea(.keyboard)
            .animation(.easeInOut(duration: 0.2), value: vm.inviteCode)
        }.navigationBarBackButtonHidden()
//            .onTapGesture { if !vm.codeAccepted { hideKeyboard() }
//            .onTapGesture { hideKeyboard() }
            .onChange(of: vm.inviteCode) {
                vm.codeMessage = ""
            }
            .alert("Authentication Failed", isPresented: $vm.socialAuthFailed) {
                Button("Ok", role: .cancel) {}
            } message: {
                Text("Please try again.")
            }
            .onChange(of: vm.navBack) {
                if vm.navBack {
                    dismiss()
                }
            }
    }
}

//#Preview {
//    AuthCreatorSignupView()
//}
