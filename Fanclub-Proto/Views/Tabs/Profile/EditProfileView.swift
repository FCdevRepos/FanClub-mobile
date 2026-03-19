//
//  EditProfileView.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 3/17/26.
//
import SwiftUI

struct EditProfileView: View {
    private let profileManager = ProfileManager.shared
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
                            Text("Edit Profile")
                                .foregroundStyle(.white)
                                .font(.custom("Nunito-Regular", size: 21))
                        }
                    }.disabled(vm.isLoading)
                    Spacer()
                    Button {
                        Task { try await vm.updateProfile() }
                    } label: {
                        if vm.isLoading {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .tint(GlobalVars.YellowText)
                                .scaleEffect(1.25)
                        } else {
                            Text("Save")
                                .foregroundStyle(GlobalVars.YellowText)
                                .font(.custom("Nunito-Regular", size: 20))
                        }
                    }.disabled(vm.isLoading)
                }.padding()
                ScrollView {
                    Image(.pfpPlaceholder)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 92, height: 92)
                        .overlay(alignment: .bottom) {
                            Button {} label: {
                                ZStack {
                                    Rectangle()
                                        .fill(.white)
                                    Image(systemName: "square.and.pencil")
                                        .foregroundStyle(.black)
                                        .imageScale(.small)
                                        .padding(5)
                                }
                            }.fixedSize().offset(y: 18)
                        }
                        .padding()
                    //PROFILE FIELDS
                    Group {
                        //NAME
                        Group {
                            HStack {
                                Text("Full Name")
                                    .foregroundStyle(.gray)
                                    .font(.custom("Montserrat-Light", size: 14))
                                Spacer()
                            }.padding(.top).padding(.horizontal)
                            HStack {
                                TextField("Enter your full name", text: $vm.newName)
                                    .foregroundStyle(.white)
                                    .font(.custom("Montserrat-Regular", size: 16))
                                    .textInputAutocapitalization(.words)
                                    .autocorrectionDisabled()
                                Spacer()
                            }.padding(.vertical, 5).padding(.horizontal)
                            Rectangle()
                                .frame(height: 0.75)
                                .foregroundStyle(.white.opacity(0.65))
                                .padding(.bottom).padding(.horizontal)
                        }
                        //USERNAME
                        Group {
                            HStack {
                                Text("Username")
                                    .foregroundStyle(.gray)
                                    .font(.custom("Montserrat-Light", size: 14))
                                Spacer()
                            }.padding(.top).padding(.horizontal)
                            HStack {
                                TextField("Enter a username", text: $vm.newUsername)
                                    .foregroundStyle(.white)
                                    .font(.custom("Montserrat-Regular", size: 16))
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                Spacer()
                            }.padding(.vertical, 5).padding(.horizontal)
                            Rectangle()
                                .frame(height: 0.75)
                                .foregroundStyle(.white.opacity(0.65))
                                .padding(.bottom).padding(.horizontal)
                        }
                        //EMAIL
                        Group {
                            //add notice for apple user for weird email if they chose to hide it?
                            //add profile field in DB that says socialAccount as a boolean? or an enum of apple, google, facebook, nil?
                            //then hide this field or make it disabled if that returns true for boolean or one of the enum values?
                            HStack {
                                Text("Email")
                                    .foregroundStyle(.gray)
                                    .font(.custom("Montserrat-Light", size: 14))
                                Spacer()
                            }.padding(.top).padding(.horizontal)
                            HStack {
                                TextField("Enter your email address", text: $vm.newEmail)
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
                                    .font(.custom("Montserrat-Light", size: 16))
                                Spacer()
                                
                                if vm.newDOBAdded {
                                    DatePicker("", selection: $vm.newDOB, in: ...(Date.now), displayedComponents: .date)
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
                                                selection: $vm.newDOB,
                                                in: ...(Date.now),
                                                displayedComponents: .date
                                            )
                                            .colorScheme(.dark)
                                            .labelsHidden()
                                            .tint(.black)
                                            .blendMode(.destinationOver) //MARK: use this extension to keep the clickable functionality
                                        }
                                }
                                
                            }.padding(.top).padding(.horizontal)
                        }
                        //COUNTRY
                        Group {
                            HStack {
                                Text("Country")
                                    .foregroundStyle(.gray)
                                    .font(.custom("Montserrat-Light", size: 14))
                                Spacer()
                            }.padding(.top).padding(.horizontal)
                            HStack {
                                Menu {
                                    ForEach(GlobalVars.countries, id: \.self) { country in
                                        Button { vm.newCountry = country } label: {
                                            HStack {
                                                Text(country)
                                                if vm.newCountry == country {
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                        }
                                    }
                                } label: {
                                    if vm.newCountry == "" {
                                        Text("Add a country +")
                                            .foregroundStyle(.white)
                                            .font(.custom("Montserrat-Regular", size: 16))
                                    } else {
                                        HStack {
                                            Text(vm.newCountry)
                                                .foregroundStyle(.white)
                                                .font(.custom("Montserrat-Regular", size: 16))
                                            Image(systemName: "chevron.up.chevron.down")
                                                .foregroundStyle(.white)
                                                .font(.system(size: 18))
                                        }
                                    }
                                }
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
//                        Button {
//                            Task { try await vm.updateProfile() }
//                        } label: {
//                            if vm.isLoading {
//                                ProgressView()
//                                    .progressViewStyle(.circular)
//                                    .tint(GlobalVars.YellowText)
//                                    .scaleEffect(1.25)
//                            } else {
//                                Text("Save Changes")
//                                    .foregroundStyle(GlobalVars.YellowText)
//                                    .font(.custom("Nunito-Regular", size: 20))
//                            }
//                        }.disabled(vm.isLoading)
                    }.padding(.bottom).padding(.horizontal)
                    Spacer()
                }
            }//.ignoresSafeArea(.keyboard)
        }.onAppear {
            vm.setEditingFields()
        }
        .navigationBarBackButtonHidden()
        .onTapGesture { hideKeyboard() }
        .alert("Update profile failed", isPresented: $vm.updateError) {
            Button("Ok", role: .cancel) {}
        } message: {
            Text("Please try again.")
        }
    }
}
