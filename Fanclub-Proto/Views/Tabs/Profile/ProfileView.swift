//
//  ProfileView.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 9/10/24.
//

import SwiftUI

struct ProfileView: View {
    private let profileManager = ProfileManager.shared
    @AppStorage("auth") var auth = false
    @StateObject var vm = ProfileVM()
    
    @State var messages: [String] = []
    
    @State var bio = ""
    
    @State var view = "stack"//stack or grid
    
    //TODO: reload this when returning from EditProfileView, currently isn't updating right away.
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.opacity(0.92).ignoresSafeArea()
                VStack {
                    //PROFILE COVER IMAGE/INFO VIEW
                    ZStack {
                        LinearGradient(colors: [.red, .black], startPoint: .top, endPoint: .bottom)
                            .ignoresSafeArea()
                        VStack {
                            HStack {
                                Text("Profile")
//                                    .foregroundStyle(GlobalVars.textColor)
                                    .foregroundStyle(GlobalVars.YellowText)
                                    .font(.title2)
                                Spacer()
//                                NavigationLink {MessagesView(msg: messages)} label: {
//                                    Image(systemName: "paperplane").foregroundStyle(.white).imageScale(.large)
//                                }.overlay(alignment: .topTrailing) {
//                                    if !messages.isEmpty { Circle().foregroundStyle(.yellow).frame(width: 8, height: 8) }
//                                }
                                NavigationLink {SettingsView()} label: {
                                    Image(systemName: "gearshape")
                                        .foregroundStyle(.white)
                                        .imageScale(.large)
                                        .padding(.leading)
                                }
                            }
                            Spacer()
                            HStack {
                                Text(profileManager.profile?.fullname ?? "")
                                    .foregroundStyle(.white)
                                    .font(.custom("Nunito-ExtraLight", size: 50))
                                Spacer()
                            }.padding(.top).padding(.bottom, 5)
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack(spacing: 3) {
//                                        Text("Age 25")//TODO -> convert DOB to age
//                                            .foregroundStyle(.white.opacity(0.8))
//                                            .font(.custom("Nunito-Regular", size: 15))
//                                        Text("·")
//                                            .foregroundStyle(.white.opacity(0.8))
//                                            .font(.custom("Nunito-Regular", size: 15))
                                        Text("\(profileManager.profile?.country ?? "United States")")
                                            .foregroundStyle(.white.opacity(0.8))
                                            .font(.custom("Nunito-Regular", size: 15))
                                    }
//                                    NavigationLink {} label: {
//                                        Text("250 Followers >")//or is this following? it says "Followings" on old app
//                                            .foregroundStyle(.white.opacity(0.8))
//                                            .font(.custom("Nunito-Regular", size: 15))
//                                    }
                                    Text("0 Followers >")//or is this following? it says "Followings" on old app
                                        .foregroundStyle(.white.opacity(0.8))
                                        .font(.custom("Nunito-Regular", size: 15))
                                }
                                Spacer()
                            }.padding(.top, 8)
                        }.padding(.top).padding(.horizontal).padding(.bottom, 6)
                    }.frame(height: 250).padding(.bottom, 15)
                    //PROFILE FIELDS
                    Group {
                        //PHONE
                        Group {
                            HStack {
                                Text("Registered Number")
                                    .foregroundStyle(.gray)
                                    .font(.custom("Montserrat-Light", size: 14))
                                Spacer()
                            }.padding(.top).padding(.horizontal)
                            HStack {
                                Text("\(profileManager.profile?.mobile ?? "")")
                                    .foregroundStyle(.white)
                                    .font(.custom("Montserrat-Regular", size: 16))
                                Spacer()
                            }.padding(.vertical, 5).padding(.horizontal)
                            Rectangle()
                                .frame(height: 0.75)
                                .foregroundStyle(.white.opacity(0.65))
                                .padding(.bottom).padding(.horizontal)
                        }
                        //EMAIL
                        Group {
                            HStack {
                                Text("Email")
                                    .foregroundStyle(.gray)
                                    .font(.custom("Montserrat-Light", size: 14))
                                Spacer()
                            }.padding(.top).padding(.horizontal)
                            HStack {
                                Text("\(profileManager.profile?.email ?? "")")
                                    .foregroundStyle(.white)
                                    .font(.custom("Montserrat-Regular", size: 16))
                                Spacer()
                            }.padding(.vertical, 5).padding(.horizontal)
                            Rectangle()
                                .frame(height: 0.75)
                                .foregroundStyle(.white.opacity(0.65))
                                .padding(.bottom).padding(.horizontal)
                        }
                        //DOB
                        Group {
                            HStack {
                                Text("Date of Birth")
                                    .foregroundStyle(.gray)
                                    .font(.custom("Montserrat-Light", size: 14))
                                Spacer()
                            }.padding(.top).padding(.horizontal)
                            HStack {
//                                Text("\(profileManager.profile?.dob ?? "")")
                                Text("\(convertYYYYMMDDDateStringToLocaleDateString(input: profileManager.profile?.dob ?? "") ?? "")")
                                    .foregroundStyle(.white)
                                    .font(.custom("Montserrat-Regular", size: 16))
                                Spacer()
                            }.padding(.vertical, 5).padding(.horizontal)
                            Rectangle()
                                .frame(height: 0.75)
                                .foregroundStyle(.white.opacity(0.65))
                                .padding(.bottom).padding(.horizontal)
                        }
                    }
                    HStack {
                        Spacer()
                        if (profileManager.profile?.influencer ?? false) {
                            NavigationLink {
                                EditInfluencerProfileView()
                            } label: {
                                Text("Edit Profile")
                                    .foregroundStyle(GlobalVars.YellowText)
                                    .font(.custom("Nunito-Regular", size: 20))
                            }
                        } else {
                            NavigationLink {
                                EditProfileView()
                            } label: {
                                Text("Edit Profile")
                                    .foregroundStyle(GlobalVars.YellowText)
                                    .font(.custom("Nunito-Regular", size: 20))
                            }
                        }
                    }.padding(.bottom).padding(.horizontal)
                    Spacer()
                }
            }
        }
        .onAppear {
            Task { try await profileManager.loadProfile { comp in }}
        }
    }
}

#Preview {
    ProfileView()
}
