//
//  AuthAddInfoView.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 3/5/26.
//
import SwiftUI

struct AuthAddInfoView: View {
//    @Binding var path: NavigationPath
    private let profileManager = ProfileManager.shared
    
    @AppStorage("auth") var auth = false
    @AppStorage("finishSignupInfo") var finishSignupInfo = false
    @AppStorage("signupInfoName") var signupInfoName = ""
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var vm = AuthVM()
    
    @FocusState var nameFocused: Bool
    @FocusState var bdayFocused: Bool
    
    @FocusState var displayNameFocused: Bool
    @FocusState var usernameFocused: Bool
    
//    var withApple: Bool
//    var withGoogle: Bool
//    var withOTP: Bool
//    
//    @Binding var afterLogin: Bool //only to be used with OTP to dismiss one more level after login
    
    var body: some View {
        ZStack {
            Color
                .black.opacity(0.92)
                .ignoresSafeArea()
            VStack {
                Text("Complete Sign Up")
                    .foregroundStyle(.white)
                    .font(.custom("Nunito-SemiBold", size: 21))
                    .padding()
                
                //PROFILE FIELDS
                Group {
                    switch vm.addInfoStep {
                    case 1:
                        //FULL NAME
                        //TODO: -> copy display name into username for influencer
                        //when display name is changed, update username
                        //but username can be updated independently
                        if vm.name != "" {
                            HStack {
                                Text("Full Name")
                                    .foregroundStyle(.white.opacity(0.7))
                                    .font(.custom("Nunito-Regular", size: 15))
                                Spacer()
                            }
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .padding(.horizontal)
                            .padding(.top)
                            .padding(.bottom, 5)
                        }
                        TextField("", text: $vm.name, prompt: Text("Full Name").foregroundStyle(.gray.opacity(0.5)))
                            .font(.custom("Montserrat-Regular", size: 20))
                            .foregroundStyle(.white)
                            .focused($nameFocused)
                            .padding(.horizontal)
                            .padding(.top, vm.name == "" ? 20 : 5)
                            .textInputAutocapitalization(.words)
                            .autocorrectionDisabled()
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(.gray)
                            .padding(.bottom)
                            .padding(.horizontal)
                            .padding(.top, 4)
                        
                        //COUNTRY
                        Group {
                            HStack {
                                Text("Country")
                                    .foregroundStyle(.white.opacity(0.7))
                                    .font(.custom("Nunito-Regular", size: 15))
                                Spacer()
                            }
                            .padding(.top).padding(.horizontal).padding(.bottom, 5)
                            HStack {
                                Menu {
                                    ForEach(GlobalVars.countries, id: \.self) { country in
                                        Button { vm.country = country } label: {
                                            HStack {
                                                Text(country)
                                                if vm.country == country {
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                        }
                                    }
                                } label: {
                                    if vm.country == "" {
                                        Text("Add a country +")
                                            .foregroundStyle(.white)
                                            .font(.custom("Montserrat-Regular", size: 17))
                                    } else {
                                        HStack {
                                            Text(vm.country)
                                                .foregroundStyle(.white)
                                                .font(.custom("Montserrat-Regular", size: 20))
                                            Image(systemName: "chevron.up.chevron.down")
                                                .foregroundStyle(.white)
                                                .font(.system(size: 18))
                                        }
                                    }
                                }
                                Spacer()
                            }.padding(.vertical, 5).padding(.horizontal)
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(.gray)
                                .padding(.bottom).padding(.horizontal)
                        }
                        
                        //BIRTHDAY
                        HStack {
                            Text("Add Birthday")
                                .foregroundStyle(.white)
                                .font(.custom("Montserrat-Regular", size: 20))
                            Spacer()
                            
                            if vm.addedBirthday {
                                DatePicker("", selection: $vm.birthday, in: ...(Date.now), displayedComponents: .date)
                                    .colorScheme(.dark)
                                    .fixedSize()
                                    .padding(10)
                                    .labelsHidden()
                                    .tint(.black)
                            } else {
                                Text("Add +")
                                    .foregroundStyle(.white)
                                    .font(.custom("Montserrat-Regular", size: 16))
                                    .padding(10)
                                    .border(.gray, width: 0.5)
                                    .overlay{ //MARK: Place the DatePicker in the overlay extension
                                        DatePicker(
                                            "",
                                            selection: $vm.birthday,
                                            in: ...(Date.now),
                                            displayedComponents: .date
                                        )
                                        .colorScheme(.dark)
                                        .labelsHidden()
                                        .tint(.black)
                                        .blendMode(.destinationOver) //MARK: use this extension to keep the clickable functionality
                                    }
                            }
                            
                        }.padding()
                        
                        if !(profileManager.profile?.influencer ?? false) {
                            //USERNAME
                            //TODO: -> copy full name into username for basic
                            //when full name is changed, update username
                            //but username can be updated independently
                            if vm.username != "" {
                                HStack {
                                    Text("Username")
                                        .foregroundStyle(.white.opacity(0.7))
                                        .font(.custom("Nunito-Regular", size: 15))
                                    Spacer()
                                }
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                                .padding(.horizontal)
                                .padding(.top)
                                .padding(.bottom, 5)
                            }
                            VStack {
                                HStack(alignment: .bottom) {
                                    Text("@")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 20))
                                    TextField("", text: $vm.username, prompt: Text("Username").foregroundStyle(.gray.opacity(0.5)))
                                        .font(.custom("Montserrat-Regular", size: 20))
                                        .foregroundStyle(.white)
                                        .focused($usernameFocused)
                                        .padding(.top, vm.username == "" ? 20 : 5)
                                        .textInputAutocapitalization(.never)
                                        .autocorrectionDisabled()
                                }
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundStyle(.gray)
                                    .padding(.bottom)
                                    .padding(.top, 4)
                            }.padding(.horizontal)
                        }
                        
                    case 2:
                        //DISPLAY NAME
                        //TODO: -> copy display name into username for influencer
                        //when display name is changed, update username
                        //but username can be updated independently
                        if vm.displayName != "" {
                            HStack {
                                Text("Display Name")
                                    .foregroundStyle(.white.opacity(0.7))
                                    .font(.custom("Nunito-Regular", size: 15))
                                Spacer()
                            }
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .padding(.horizontal)
                            .padding(.top)
                            .padding(.bottom, 5)
                        }
                        TextField("", text: $vm.displayName, prompt: Text("Display Name").foregroundStyle(.gray.opacity(0.5)))
                            .font(.custom("Montserrat-Regular", size: 20))
                            .foregroundStyle(.white)
                            .focused($displayNameFocused)
                            .padding(.horizontal)
                            .padding(.top, vm.displayName == "" ? 20 : 5)
                            .textInputAutocapitalization(.words)
                            .autocorrectionDisabled()
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(.gray)
                            .padding(.bottom, 5)
                            .padding(.horizontal)
                            .padding(.top, 4)
                        Text("If you do not enter a display name, your full name will be shown to users.")
                            .foregroundStyle(.gray.opacity(0.65))
                            .font(.custom("Nunito-Italic", size: 14))
                            .padding(.top, 5)
                            .padding(.horizontal)
                            .padding(.bottom)
                        
                        //USERNAME
                        //TODO: -> copy display name into username for influencer
                        //when display name is changed, update username
                        //but username can be updated independently
                        if vm.username != "" {
                            HStack {
                                Text("Username")
                                    .foregroundStyle(.white.opacity(0.7))
                                    .font(.custom("Nunito-Regular", size: 15))
                                Spacer()
                            }
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .padding(.horizontal)
                            .padding(.top)
                            .padding(.bottom, 5)
                        }
                        VStack {
                            HStack(alignment: .bottom) {
                                Text("@")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 20))
                                TextField("", text: $vm.username, prompt: Text("Username").foregroundStyle(.gray.opacity(0.5)))
                                    .font(.custom("Montserrat-Regular", size: 20))
                                    .foregroundStyle(.white)
                                    .focused($usernameFocused)
                                    .padding(.top, vm.username == "" ? 20 : 5)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                            }
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(.gray)
                                .padding(.bottom)
                                .padding(.top, 4)
                        }.padding(.horizontal)
                        
                        //show username error text upon submitting and getting "username taken" error?
                        //or show alert?
                        
                        //BRAND
                        HStack {
                            Button { vm.isBrand.toggle() } label: {
                                HStack {
                                    Image(systemName: vm.isBrand ? "checkmark.square" : "square")
                                        .foregroundStyle(.white)
                                        .imageScale(.large)
                                    Text("Check this box if you are a Brand")
                                        .foregroundStyle(.white)
                                        .font(.custom("Montserrat-Regular", size: 18))
                                }
                            }
                            Spacer()
                        }.padding()
                    default: EmptyView()
                    }
                }
                Spacer()
                if vm.showAgeError {
                    Text("You must be at least 18 years old to join FanClub")
                        .foregroundStyle(.red)
                        .font(.custom("Nunito-Regular", size: 13))
                        .multilineTextAlignment(.center)
                        .padding()
                }
                Button {
                    if !(profileManager.profile?.influencer ?? false) || ((profileManager.profile?.influencer ?? false) && vm.addInfoStep == 2) {
                        Task { try await vm.updateProfile() }
                    } else {
                        withAnimation {
                            //set display name, set username
                            vm.displayName = vm.name
                            vm.username = vm.displayName.replacingOccurrences(of: " ", with: "").lowercased()
                            vm.addInfoStep = 2
                        }
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(vm.checkAddInfoButtonEnabled() ? GlobalVars.PurpleButtonColor : GlobalVars.GrayButtonColor)
                        if vm.isLoading {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .tint(.white)
                                .padding()
                        } else {
                            if !(profileManager.profile?.influencer ?? false) || ((profileManager.profile?.influencer ?? false) && vm.addInfoStep == 2) {
                                Text("Finish")
                                    .font(.custom("Nunito-Medium", size: 18))
                                    .padding()
                                    .foregroundStyle(.white)
                            } else {
                                Text("Continue")
                                    .font(.custom("Nunito-Medium", size: 18))
                                    .padding()
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                .disabled(!vm.checkAddInfoButtonEnabled() || vm.showAgeError)
                .padding()
                
                if vm.addInfoStep == 2 {
                    Button {
                        withAnimation { vm.addInfoStep = 1 }
                    } label: {
                        Text("Back")
                            .foregroundStyle(.white)
                            .font(.custom("Nunito-Regular", size: 16))
                    }.padding()
                }
                
                if vm.passButton && !vm.isLoading && (!(profileManager.profile?.influencer ?? false) || ((profileManager.profile?.influencer ?? false) && vm.addInfoStep == 2)) {
                    Button {
                        signupInfoName = ""
                        finishSignupInfo = false
                    } label: {
                        Text("Add profile info later")
                            .foregroundStyle(.gray)
                            .font(.custom("Nunito-Light", size: 15))
                    }.padding()
                }
            }
            .animation(.easeInOut(duration: 0.2), value: nameFocused)
            .animation(.easeInOut(duration: 0.2), value: vm.name)
            .animation(.easeInOut(duration: 0.2), value: displayNameFocused)
            .animation(.easeInOut(duration: 0.2), value: vm.displayName)
            .animation(.easeInOut(duration: 0.2), value: usernameFocused)
            .animation(.easeInOut(duration: 0.2), value: vm.username)
            .padding(.top, 30)
        }
        .navigationBarBackButtonHidden().onTapGesture { hideKeyboard() }.disableSwipeBack()
        .ignoresSafeArea(.keyboard)
        .onChange(of: vm.birthday) {
            vm.addedBirthday = true
        }
        .onAppear {
            vm.name = signupInfoName
            print("Influencer: \(profileManager.profile?.influencer ?? false)")
        }
        .alert("Update profile failed", isPresented: $vm.updateFailure) {
            Button("Ok", role: .cancel) { vm.passButton = true }
        } message: {
            Text("Please try again or continue without updating.")
        }
        .onChange(of: vm.birthday) {
            vm.addedBirthday = true
            if vm.addedBirthday {
                vm.showAgeError = !vm.check18YO()
            }
        }
        .onChange(of: vm.name) {
            if !(profileManager.profile?.influencer ?? false) {
                vm.username = vm.name.replacingOccurrences(of: " ", with: "").lowercased()
            }
        }
        .onChange(of: vm.displayName) {
            vm.username = vm.displayName.replacingOccurrences(of: " ", with: "").lowercased()
        }
        .onChange(of: vm.username) {
            vm.username = vm.username.replacingOccurrences(of: " ", with: "").lowercased()
            if vm.username.count > 32 {
                vm.username.removeLast()
            }
        }
    }
}

//#Preview {
////    AuthAddInfoView(withApple: false, withGoogle: false, withOTP: false, afterLogin: .constant(false))
//    AuthAddInfoView()
//}

