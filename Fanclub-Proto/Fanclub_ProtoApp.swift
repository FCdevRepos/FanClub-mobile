//
//  Fanclub_ProtoApp.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 9/10/24.
//

import SwiftUI
import Foundation
import UIKit

@main
struct Fanclub_ProtoApp: App {
    private let profileManager = ProfileManager.shared
    
    @AppStorage("auth") var auth = false
    @AppStorage("userId") var userId = 0
    @AppStorage("finishSignupInfo") var finishSignupInfo = false
    
    @State var isLoading = false
    
    init() {
//        UITabBar.appearance().backgroundColor = UIColor.gray.withAlphaComponent(0.35)
//        UITabBarItemAppearance().normal.iconColor = UIColor.purple
//        UITabBar.appearance().isTranslucent = false
        
//        UITabBar.appearance().barTintColor = UIColor.white
//        UITabBar.appearance().isTranslucent = false
//        UITabBar.appearance().barTintColor = .black.withAlphaComponent(0.88)
        
            //figure out way to reset navigation when re-clicking on tabbar tab
        
        
        //real values i use for tab bar - not needed in iOS 26 tho
//        UITabBar.appearance().backgroundColor = UIColor.gray.withAlphaComponent(0.325)
//
//        UISegmentedControl.appearance().backgroundColor = .gray
//        UISegmentedControl.appearance().selectedSegmentTintColor = GlobalVars.purpleColor
//        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.black], for: .normal)
//        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.black], for: .selected)
//        
//        UIDatePicker.appearance().tintColor = .systemBlue
//        
//        UISlider.appearance().minimumTrackTintColor = .yellow
//        UISlider.appearance().maximumTrackTintColor = .white
//        UISlider.appearance().thumbTintColor = .yellow
//        
//        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = .black
        
//        UIDatePicker.appearance().tintColor = .blue
        
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if isLoading {
                    ZStack {
                        Color
                            .black.opacity(0.92)
                            .ignoresSafeArea()
                        VStack {
                            Spacer()
                            Image(.FANCLUB)
                                .resizable()
                                .frame(width: 280, height: 170)
                                .padding()
                            ProgressView()
                                .progressViewStyle(.circular)
                                .tint(.white)
                                .scaleEffect(1.25)
                            Spacer()
                        }
                    }
                } else {
                    if !auth {
                        AuthView()
                    } else {
                        if finishSignupInfo {
                            //set isCreator to true if (profileManager.profile?.influencer ?? false) == true
                            AuthAddInfoView()
                        } else {
                            ContainerTabView()
                        }
                    }
                }
            }.onAppear {
                isLoading = true
                Task {
                    try await profileManager.loadProfile(uid: userId) { comp in
                        //this endpoint doesnt need an accessToken so it wont really know if we are truly logged in or not.
                        //maybe try calling one that does?
                        if comp != 200 {
                            auth = false
                            userId = 0
                        } else {
                            auth = true
                        }
                    }
                    isLoading = false
                }
                print("auth: \(auth)")
            }
        }
    }
    
//    @State var navPath = NavigationPath()
//    
//    var body: some Scene {
//        WindowGroup {
////            AuthView()
//            NavigationStack(path: $navPath) {
//                RootRouterView(path: $navPath)
//                    .navigationDestination(for: AppRoute.self) { route in
//                        switch route {
//                        case .landing:
//                            AuthView(path: $navPath)
//                        case .creatorSignup:
//                            AuthCreatorSignupView(path: $navPath)
//                        case .signupAddInfo(let name, let email, let phone, let birthday):
//                            AuthAddInfoView(path: $navPath, name: name, email: email, phone: phone, birthday: birthday)
//                        case .home:
//                            DiscoverView()
//                        }
//                    }
//            }
//            .onAppear { finishSignupInfo = false }
//        }
//    }
}

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color
                .black.opacity(0.92)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Image(.FANCLUB)
                    .resizable()
                    .frame(width: 280, height: 200)
                    .padding(.top, 50)
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .scaleEffect(1.65)
                    .padding(.bottom)
                Spacer()
            }
        }
    }
}

struct RootRouterView: View {
    @Binding var path: NavigationPath
    
    @AppStorage("auth") var auth = false
    @AppStorage("userId") var userId = 0
    @AppStorage("finishSignupInfo") var finishSignupInfo = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            if auth {
//                if finishSignupInfo {
//                    AuthAddInfoView(path: $path)
//                } else {
//                    ContainerTabView()
//                }
                ContainerTabView()
            } else {
//                AuthView(path: $path)
                AuthView()
            }
        }.navigationBarBackButtonHidden()
            .task {
                print("called task in RootRouterView")
                
                //get logged in user info -> check token in UD and if not found, log out (set auth to false)
                if UserDefaults.standard.string(forKey: "accessToken") == nil {
                    auth = false
                    userId = 0
                }
                
                //also try using it in an api call to get User Profile, and if it returns unauthorized, log out and set token to blank
            }
    }
}

enum AppRoute: Hashable {
    case landing
    case creatorSignup
    case home
    case signupAddInfo(name: String, email: String, phone: String, birthday: String)
}
