//
//  SocialMediaLinksView.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 4/12/26.
//
import SwiftUI

struct SocialMediaLinksView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm = ProfileVM()
    
    var body: some View {
        ZStack {
            Color
                .black.opacity(0.92)
                .ignoresSafeArea()
            VStack {
                HStack {
                    Button { dismiss() } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                                .imageScale(.large)
                                .foregroundStyle(.white)
                            Text("Social Media Links")
                                .foregroundStyle(.white)
                                .font(.custom("Nunito-Regular", size: 21))
                        }
                    }.disabled(vm.isLoading)
                    Spacer()
                    Button {
                        Task { try await vm.updateSocialLinks() }
                    } label: {
                        if vm.isLoading {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .tint(GlobalVars.YellowText)
                                .scaleEffect(1.25)
                        } else {
                            Text("Save")
                                .foregroundStyle(vm.socialsSaveButtonDisabled() ? .gray : GlobalVars.YellowText)
                                .font(.custom("Nunito-Regular", size: 20))
                        }
                    }.disabled(vm.isLoading || vm.socialsSaveButtonDisabled())
                }.padding()
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(Array(vm.links.keys), id: \.self) { key in
                            if let _ = vm.links[key] {
                                SocialLinkEdit(platform: key, value: Binding(
                                    get: {
                                        if let value = vm.links[key] {
                                            return String(value)
                                        } else {
                                            return ""
                                        }
                                    },
                                    set: { newValue in
                                        vm.links[key] = newValue
                                    }
                                ))
                            }
                        }
                    }
                }
            }
        }.navigationBarBackButtonHidden().onTapGesture { hideKeyboard() }
            .onAppear { Task { try await vm.getSocialLinks() } }
    }
}

struct SocialLinkEdit: View {
    let platform: String
    @Binding var value: String
    
    var body: some View {
        HStack {
            Image("sm-\(platform)")
                .resizable()
                .frame(width: 32, height: 32)
            VStack(spacing: 4) {
                TextField("Username or profile link", text: $value)
                    .foregroundStyle(.white)
                    .font(.custom("Montserrat-Regular", size: 17))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                Rectangle()
                    .frame(height: 0.4)
                    .foregroundStyle(.white.opacity(0.65))
            }.padding(.horizontal, 10)
            Button { value = "" } label: {
                Image(systemName: "xmark")
                    .foregroundStyle(.white)
                    .imageScale(.medium)
                
            }
        }.padding(.vertical).padding(.horizontal, 10)
    }
}

//# platform IDs:
//#       1 = linkedin
//#       2 = instagram
//#       3 = twitter
//#       4 = soundcloud
//#       5 = spotify
//#       6 = tiktok
//#       7 = pinterest
//#       8 = youtube
//#       9 = twitch
//#       10 = telegram
//#       11 = discord
//#       12 = apple music
//#       13 = opensea
