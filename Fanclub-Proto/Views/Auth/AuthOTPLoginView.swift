//
//  AuthOTPLoginView.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 3/5/26.
//
import SwiftUI


struct AuthOTPLoginView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var vm = AuthVM()
    
    @State var afterLogin = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.92).ignoresSafeArea()
            VStack {
                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.white)
                            .font(.title)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Login with OTP")
                            .foregroundStyle(.white)
                            .font(.custom("Nunito-SemiBold", size: 24))
                    }
                }.padding()
                VStack(spacing: 4) {
                    if vm.otpStep == 1 {
                        if vm.phoneNumber != "" {
                            HStack {
                                Text("Phone Number")
                                    .foregroundStyle(.white.opacity(0.7))
                                    .font(.custom("Nunito-Regular", size: 15))
                                Spacer()
                            }
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .padding(.horizontal)
                            .padding(.top)
                            .padding(.bottom, 5)
                        }
                        HStack(spacing: 0) {
                            Menu {} label: {
                                Text("+\(vm.countryCode)")
                                    .foregroundStyle(.white)
                                    .font(.custom("Montserrat-Regular", size: 20))
                            }
                            TextField("", text: $vm.phoneNumber, prompt: Text("Phone Number").foregroundStyle(.gray.opacity(0.5)))
                                .font(.custom("Montserrat-Regular", size: 20))
                                .foregroundStyle(.white)
                                .keyboardType(.numberPad)
                                .padding(.leading)
                        }
                        .padding(.horizontal)
                        .padding(.top, vm.phoneNumber == "" ? 20 : 5)
                    } else if vm.otpStep == 2 {
                        if vm.otpCode != "" {
                            HStack {
                                Text("OTP Code")
                                    .foregroundStyle(.white.opacity(0.7))
                                    .font(.custom("Nunito-Regular", size: 15))
                                Spacer()
                            }
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .padding(.horizontal)
                            .padding(.top)
                            .padding(.bottom, 5)
                        }
                        TextField("", text: $vm.otpCode, prompt: Text("OTP Code").foregroundStyle(.gray.opacity(0.5)))
                            .font(.custom("Montserrat-Regular", size: 20))
                            .foregroundStyle(.white)
                            .padding(.horizontal)
                            .padding(.top, vm.otpCode == "" ? 20 : 5)
                            .keyboardType(.numberPad)
                    }
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.gray)
                        .padding(.bottom)
                        .padding(.horizontal)
                        .padding(.top, 4)
                    if vm.otpStep == 1 {
                        Button {
//                            withAnimation { vm.otpStep += 1 }
                            //how do we know when to signup and when to login?
                            Task { try await vm.loginOTP() }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(vm.phoneNumber.count < 10 ? GlobalVars.GrayButtonColor : GlobalVars.PurpleButtonColor)
                                if vm.isLoading {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .tint(.white)
                                        .padding()
                                } else {
                                    Text("Get Code")
                                        .font(.custom("Nunito-Medium", size: 18))
                                        .foregroundStyle(.white)
                                        .padding()
                                }
                            }
                        }
                        .fixedSize()
                        .disabled(vm.phoneNumber.count < 10 || vm.isLoading)
                        .padding()
                    } else if vm.otpStep == 2 {
                        Button {
                            Task { try await vm.loginOTP() }
                        } label: {
//                        NavigationLink { AuthAddInfoView(withApple: false, withGoogle: false, withOTP: true, afterLogin: $afterLogin) } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(vm.otpCode.isEmpty ? GlobalVars.GrayButtonColor : GlobalVars.PurpleButtonColor)
                                if vm.isLoading {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .tint(.white)
                                        .padding()
                                } else {
                                    Text("Submit Code")
                                        .font(.custom("Nunito-Medium", size: 18))
                                        .foregroundStyle(.white)
                                        .padding()
                                }
                            }
                        }
                        .fixedSize()
                        .disabled(vm.otpCode.isEmpty || vm.isLoading)
                        .padding()
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: vm.phoneNumber)
                .animation(.easeInOut(duration: 0.2), value: vm.otpCode)
                .padding(.vertical, 30)
                Spacer()
            }
        }.navigationBarBackButtonHidden().onTapGesture { hideKeyboard() }
            .onAppear {
                if afterLogin { withAnimation { dismiss() } }
            }
    }
}

#Preview {
    AuthOTPLoginView()
}
