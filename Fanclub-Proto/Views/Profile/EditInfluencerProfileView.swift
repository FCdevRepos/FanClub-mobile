//
//  EditInfluencerProfileView.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 3/17/26.
//
import SwiftUI

struct EditInfluencerProfileView: View {
    private let profileManager = ProfileManager.shared
    @Environment(\.dismiss) var dismiss
    @StateObject var vm = ProfileVM()
    
    //TODO: copied from EditProfileView -> adjust fields for influencer
    
    var body: some View {
        ZStack {
            Color
                .black.opacity(0.92)
                .ignoresSafeArea()
            VStack {
                ScrollView {
                    ZStack(alignment: .top) {
                        Image(.dummyprofile)
                            .resizable()
                            .frame(maxHeight: 205)
                            .ignoresSafeArea()
                        HStack {
                            Button { dismiss() } label: {
                                HStack {
                                    Image(systemName: "chevron.left")
                                        .imageScale(.large)
                                        .foregroundStyle(.white)
                                    Text("Edit Profile")
                                        .foregroundStyle(.white)
                                        .font(.custom("Nunito-Regular", size: 22))
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
                                        .font(.custom("Nunito-Regular", size: 22))
                                }
                            }.disabled(vm.isLoading)
                        }.padding()
                    }.overlay(alignment: .bottom) {
                        HStack {
                            Spacer()
                            //edit pfp
                            Image(.pfpPlaceholder)
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 85, height: 85)
                                .padding(.leading)
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
                                    }.fixedSize().offset(y: 18).padding(.leading)
                                }
                            Spacer()
                            Button {} label: {
                                ZStack {
                                    Rectangle()
                                        .fill(.white)
                                    Image(systemName: "square.and.pencil")
                                        .foregroundStyle(.black)
                                        .font(.title3)
                                        .padding(5)
                                }
                            }.fixedSize().offset(y: 15).padding(.trailing)
                        }.offset(y: 30)
                    }.padding(.bottom, 60)
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
                        //TITLE
                        Group {
                            HStack {
                                Text("Title")
                                    .foregroundStyle(.gray)
                                    .font(.custom("Montserrat-Light", size: 14))
                                Spacer()
                            }.padding(.top).padding(.horizontal)
                            HStack {
                                TextField("Enter a title", text: $vm.newTitle)
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
                        //DISPLAY NAME
                        Group {
                            HStack {
                                Text("Display Name")
                                    .foregroundStyle(.gray)
                                    .font(.custom("Montserrat-Light", size: 14))
                                Spacer()
                            }.padding(.top).padding(.horizontal)
                            HStack {
                                TextField("", text: $vm.newDisplayName, prompt: Text("If blank, your Full Name will be displayed").foregroundStyle(.gray.opacity(0.3)))
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
                        //BIO
                        Group {
                            HStack {
                                Text("Add a Bio")
                                    .foregroundStyle(.gray)
                                    .font(.custom("Montserrat-Light", size: 14))
                                Spacer()
                            }.padding(.top).padding(.horizontal)
                            TextField("", text: $vm.newBio, axis: .vertical)
                                .lineLimit(4, reservesSpace: true)
                                .foregroundStyle(.white)
                                .font(.custom("Montserrat-Regular", size: 16))
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .padding(.vertical, 5).padding(.horizontal)
                            Rectangle()
                                .frame(height: 0.75)
                                .foregroundStyle(.white.opacity(0.65))
                                .padding(.horizontal)
                            HStack {
                                Spacer()
                                Text("\(150 - vm.newBio.count) characters left")
                                    .foregroundStyle(.white.opacity(0.75))
                                    .font(.custom("Montserrat-Light", size: 14))
                            }.padding(.bottom).padding(.horizontal)
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
                        //MATURE CONTENT
                        Group {
                            HStack {
                                Text("Age appropriate content")
                                    .foregroundStyle(.gray)
                                    .font(.custom("Montserrat-Light", size: 16))
                                Spacer()
                                Toggle(isOn: $vm.matureContent) {}
                                    .tint(GlobalVars.PurpleButtonColor)
                                
                            }.padding(.top).padding(.horizontal)
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
        .onChange(of: vm.newBio) {
            if vm.newBio.count > 150 {
                vm.newBio = String(vm.newBio.prefix(150))
            }
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
