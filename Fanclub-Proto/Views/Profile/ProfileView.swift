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
    @AppStorage("userId") var userId = 0
    @StateObject var vm = ProfileVM()
    
    @State var messages: [String] = []
    
    let PlaceholderBGColor = Color(red: 44/255, green: 44/255, blue: 44/255)
    let BioSectionBGColor = Color(red: 40/255, green: 40/255, blue: 40/255)
    
    //TODO: reload this when returning from EditProfileView, currently isn't updating right away.
    
    //TODO: separate views for Influencer vs Basic profile? more fields shown here for influencer
    var body: some View {
        NavigationStack {
            ZStack {
                Color
                    .black.opacity(0.92)
                    .ignoresSafeArea()
                VStack {
                    //PROFILE COVER IMAGE/INFO VIEW
                    HStack {
                        Text("Profile")
                            .foregroundStyle(GlobalVars.YellowText)
                            .font(.title2)
                        Spacer()
//                        NavigationLink {MessagesView(msg: messages)} label: {
//                            Image(systemName: "paperplane").foregroundStyle(.white).imageScale(.large)
//                        }.overlay(alignment: .topTrailing) {
//                            if !messages.isEmpty { Circle().foregroundStyle(.yellow).frame(width: 8, height: 8) }
//                        }
                        NavigationLink {SettingsView()} label: {
                            Image(systemName: "gearshape")
                                .foregroundStyle(.white)
                                .imageScale(.large)
                                .padding(.leading)
                        }
                        if profileManager.profile?.influencer ?? false {
                            NavigationLink {NotificationsView()} label: {
                                Image(systemName: "bell")
                                    .foregroundStyle(.white)
                                    .imageScale(.large)
                                    .padding(.leading)
                            }
                            NavigationLink {MessagesView()} label: {
                                Image(systemName: "paperplane")
                                    .foregroundStyle(.white)
                                    .imageScale(.large)
                                    .padding(.leading)
                            }
                        }
                    }.padding(.horizontal)
                    switch profileManager.profile?.influencer ?? false {
                    case true:
                        ZStack {
                            //TODO: cover image, full width, 250 height?
                            Image(.dummyprofile)
                                .resizable()
                                .frame(maxHeight: 210)
                            HStack {
                                //PFP, circle, 100 x 100?
//                                VStack {
                                    ZStack {
                                        Circle()
                                            .fill(PlaceholderBGColor)
                                            .frame(width: 150, height: 150)
                                        Image("ProfileSel")
                                            .resizable()
                                            .frame(width: 70, height: 90)
                                    }//.padding(.vertical)
//                                    Text("@\(profileManager.profile?.username ?? "")")
//                                        .foregroundStyle(.white.opacity(0.75))
//                                        .font(.custom("Nunito-ExtraLight", size: 17))
//                                        .lineLimit(1)
//                                        .minimumScaleFactor(0.75)
//                                }
                                //TODO: show username somewhere?
                                VStack(alignment: .leading, spacing: 7) {
                                    if (profileManager.profile?.display_name ?? "") != "" {
                                        Text(profileManager.profile?.display_name ?? "")
                                            .foregroundStyle(.white)
                                            .font(.custom("Nunito-SemiBold", size: 25))
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(2)
                                            .minimumScaleFactor(0.5)
                                    } else {
                                        Text(profileManager.profile?.fullname ?? "")
                                            .foregroundStyle(.white)
                                            .font(.custom("Nunito-SemiBold", size: 25))
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(2)
                                            .minimumScaleFactor(0.5)
                                    }
//                                    Text(profileManager.profile?.title ?? "")
//                                        .foregroundStyle(.gray)
//                                        .font(.custom("Nunito-Regular", size: 16))
//                                        .lineLimit(1)
//                                        .minimumScaleFactor(0.8)
                                    //followers, fans navlink to list?
                                    NavigationLink {} label: {
                                        HStack(spacing: 7) {
                                            //followers then fans navlink to followers list?
                                            Text("\(profileManager.profile?.followers_count_platform_user_popular_on ?? "0") Followers")
                                                .font(.custom("Nunito-Regular", size: 16))
                                                .foregroundStyle(.white)
                                            Rectangle()
                                                .frame(width: 5, height: 5)
                                                .foregroundStyle(.white)
                                            //"fans" not a field on User model?
                                            Text("0 Fans >")
                                                .font(.custom("Nunito-Regular", size: 16))
                                                .foregroundStyle(.white)
                                        }
                                    }
                                    NavigationLink {} label: {
                                        HStack(spacing: 7) {
                                            //following? not a field on User model?
                                            Text("0 Following >")
                                                .font(.custom("Nunito-Regular", size: 16))
                                                .foregroundStyle(.white)
                                        }
                                    }
                                    //following count navlink to following list?
                                    //TODO: not a field on User model?
                                    HStack {
                                        NavigationLink { EditInfluencerProfileView() } label: {
                                            Text("Edit Profile")
                                                .foregroundStyle(.white.opacity(0.7))
                                                .font(.custom("Montserrat-Light", size: 16))
                                        }.padding(.trailing, 30)
                                        //Social Links navlink? or copy profile?
//                                        NavigationLink {} label: {
                                         Button {} label: {
                                            Image(systemName: "link")
                                                .fontWeight(.light)
                                                .foregroundStyle(.white.opacity(0.7))
                                                .imageScale(.large)
                                        }.padding(.trailing, 10)
//                                        NavigationLink {} label: {
                                        Button {} label: {
                                            Image(systemName: "wallet.bifold")
                                                .fontWeight(.light)
                                                .foregroundStyle(.white.opacity(0.7))
                                                .imageScale(.large)
                                            //TODO: show notif badge?
                                        }
                                        //Wallet navlink
                                    }.padding(.top, 10)
                                }.padding(.vertical).padding(.leading)
                            }//.padding(.horizontal, 8)
                        }.padding(.bottom, -10)
                        //bio section
                        ZStack {
                            Rectangle()
                                .foregroundStyle(BioSectionBGColor)
                            VStack {
                                HStack {
                                    Text("Bio")
                                        .foregroundStyle(.white)
                                        .font(.custom("Nunito-SemiBold", size: 24))
                                    Spacer()
                                }.padding(.top, 8).padding(.bottom).padding(.horizontal)
                                if (profileManager.profile?.bio ?? "") == "" {
                                    Text("User has not added a bio yet")
                                        .foregroundStyle(.white)
                                        .font(.custom("Montserrat-Regular", size: 16))
                                        .padding(.bottom)
                                        .padding(.top, 5)
                                        .multilineTextAlignment(.leading)
                                } else {
                                    Text("\(profileManager.profile?.bio ?? "")")
                                        .foregroundStyle(.white)
                                        .font(.custom("Montserrat-Regular", size: 16))
                                        .multilineTextAlignment(.leading)
                                        .padding(.bottom)
                                        .padding(.top, 5)
                                }
                                Spacer()
                            }
                        }.fixedSize(horizontal: false, vertical: true).frame(minWidth: UIScreen.main.bounds.width)//.frame(minWidth: UIScreen.main.bounds.width, minHeight: 100, maxHeight: 250)
                        
                        //link social media accounts? as in Profile Links, not verified links
                        Spacer()
                        HStack {
                            NavigationLink { SocialMediaLinksView() } label: {
                                Text("Link your Social Media accounts +")
                                    .foregroundStyle(.white)
                                    .font(.custom("Nunito-Regular", size: 18))
                                    .lineLimit(1)
                            }
                            Spacer()
                        }.padding(.horizontal).padding(.top).padding(.bottom, 40)
                    case false:
                        HStack {
                            Text(profileManager.profile?.fullname ?? "")
                                .foregroundStyle(.white)
                                .font(.custom("Nunito-ExtraLight", size: 50))
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }.padding(.top)
                        HStack {
                            Text("@\(profileManager.profile?.username ?? "")")
                                .foregroundStyle(.white.opacity(0.75))
                                .font(.custom("Nunito-ExtraLight", size: 20))
                            Spacer()
                        }.padding(.bottom, 4)
                        HStack {
                            VStack(alignment: .leading) {
                                HStack(spacing: 3) {
                                    Text("\(profileManager.profile?.country ?? "United States")")
                                        .foregroundStyle(.white.opacity(0.8))
                                        .font(.custom("Nunito-Regular", size: 18))
                                }
                                
                            }
                            Spacer()
                        }//.padding(.top, 8)
                        Divider()
                        //PROFILE FIELDS
                        Group {
//                            //PHONE
//                            Group {
//                                HStack {
//                                    Text("Registered Number")
//                                        .foregroundStyle(.gray)
//                                        .font(.custom("Montserrat-Light", size: 14))
//                                    Spacer()
//                                }.padding(.top)
//                                HStack {
//                                    Text("\(profileManager.profile?.mobile ?? "")")
//                                        .foregroundStyle(.white)
//                                        .font(.custom("Montserrat-Regular", size: 16))
//                                    Spacer()
//                                }.padding(.vertical, 5)
//                                Rectangle()
//                                    .frame(height: 0.75)
//                                    .foregroundStyle(.white.opacity(0.65))
//                                    .padding(.bottom)
//                            }
                            //EMAIL
                            Group {
                                HStack {
                                    Text("Email")
                                        .foregroundStyle(.gray)
                                        .font(.custom("Montserrat-Light", size: 14))
                                    Spacer()
                                }.padding(.top)
                                HStack {
                                    Text("\(profileManager.profile?.email ?? "")")
                                        .foregroundStyle(.white)
                                        .font(.custom("Montserrat-Regular", size: 16))
                                    Spacer()
                                }.padding(.vertical, 5)
                                Rectangle()
                                    .frame(height: 0.75)
                                    .foregroundStyle(.white.opacity(0.65))
                                    .padding(.bottom)
                            }
                            //DOB
                            Group {
                                HStack {
                                    Text("Date of Birth")
                                        .foregroundStyle(.gray)
                                        .font(.custom("Montserrat-Light", size: 14))
                                    Spacer()
                                }.padding(.top)
                                HStack {
    //                                Text("\(profileManager.profile?.dob ?? "")")
                                    Text("\(convertYYYYMMDDDateStringToLocaleDateString(input: profileManager.profile?.dob ?? "") ?? "")")
                                        .foregroundStyle(.white)
                                        .font(.custom("Montserrat-Regular", size: 16))
                                    Spacer()
                                }.padding(.vertical, 5)
                                Rectangle()
                                    .frame(height: 0.75)
                                    .foregroundStyle(.white.opacity(0.65))
                                    .padding(.bottom)
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
                        }
                        Spacer()
                        if !(profileManager.profile?.is_verification_requested ?? false) {
                            
                            HStack {
                                NavigationLink { VerifySocialMediaView() } label: {
//                                    Text("Link your Social Media accounts +")
                                    Text("Verify your Social Media accounts +")
                                        .foregroundStyle(.white)
                                        .font(.custom("Nunito-Regular", size: 18))
                                        .lineLimit(1)
                                }
                                Spacer()
                            }.padding(.horizontal).padding(.top).padding(.bottom, 40)
                        } else {
                            if ((profileManager.profile?.verification_status ?? "") == "in_progress") {
                                HStack {
                                    Text("Your creator verification is pending. You will be notified when it is approved or rejected.")
                                        .multilineTextAlignment(.leading)
                                        .foregroundStyle(.white)
                                        .font(.custom("Nunito-Regular", size: 16))
                                    Spacer()
                                }.padding(.horizontal).padding(.top).padding(.bottom, 40)
                            } else {
                                //if rejected show message and allow them to resubmit socials? or something else?
                                //if approved, they won't see this section because they will have influencer profile view
                                
                                //this also may need to be placed in the block above since the is_verification_requested is set back to false. we may there need to cehck the verfication_status if it is rejected or something similar
                            }
                        }
                    }
                }.padding()
            }
        }
        .onAppear {
            Task { try await profileManager.loadProfile(uid: userId) { comp in }}
        }
    }
}

#Preview {
    ProfileView()
}
