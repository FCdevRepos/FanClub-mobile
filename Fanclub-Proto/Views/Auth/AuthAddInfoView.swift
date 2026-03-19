//
//  AuthAddInfoView.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 3/5/26.
//
import SwiftUI

struct AuthAddInfoView: View {
//    @Binding var path: NavigationPath
    
    @AppStorage("auth") var auth = false
    @AppStorage("finishSignupInfo") var finishSignupInfo = false
    @AppStorage("signupInfoName") var signupInfoName = ""
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var vm = AuthVM()
    
    @FocusState var nameFocused: Bool
    @FocusState var bdayFocused: Bool
    
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
                    //NAME
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
                }
                Spacer()
                Button {
                    //first update profile if changed
                    Task { try await vm.updateProfile() }
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
                            Text("Continue")
                                .font(.custom("Nunito-Medium", size: 18))
                                .padding()
                                .foregroundStyle(.white)
                        }
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                .disabled(!vm.checkAddInfoButtonEnabled())
                .padding()
                
                if vm.passButton && !vm.isLoading {
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
            .padding(.top, 30)
        }
        .navigationBarBackButtonHidden().onTapGesture { hideKeyboard() }.disableSwipeBack()
        .ignoresSafeArea(.keyboard)
        .onChange(of: vm.birthday) {
            vm.addedBirthday = true
        }
        .onAppear {
            vm.name = signupInfoName
        }
        .alert("Update profile failed", isPresented: $vm.updateFailure) {
            Button("Ok", role: .cancel) { vm.passButton = true }
        } message: {
            Text("Please try again or continue without updating.")
        }
        .onChange(of: vm.birthday) {
            vm.addedBirthday = true
        }
    }
}

//#Preview {
////    AuthAddInfoView(withApple: false, withGoogle: false, withOTP: false, afterLogin: .constant(false))
//    AuthAddInfoView()
//}

