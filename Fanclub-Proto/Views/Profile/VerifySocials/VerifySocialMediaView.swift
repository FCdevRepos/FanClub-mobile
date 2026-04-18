//
//  VerifySocialMediaView.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 3/27/26.
//
import SwiftUI

struct VerifySocialMediaView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm = VerifySocialMediaVM()
    
    var body: some View {
        ZStack {
            Color
                .black.opacity(0.92)
                .ignoresSafeArea()
            VStack {
                HStack(alignment: .top) {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .imageScale(.large)
                            .foregroundStyle(.white)
                    }
                    Spacer()
                    VStack(spacing: 5) {
                        Text("Become a Creator")
                            .foregroundStyle(.white)
                            .font(.custom("Nunito-SemiBold", size: 24))
                        switch vm.step {
                        case 1:
                            Text("Creator Info")
                                .foregroundStyle(.white.opacity(0.8))
                                .font(.custom("Nunito-Regular", size: 20))
                                .padding(.bottom, 10)
                        case 2:
                            Text("Terms and Conditions")
                                .foregroundStyle(.white.opacity(0.8))
                                .font(.custom("Nunito-Regular", size: 20))
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                                .padding(.bottom, 10)
                        case 3:
                            Text("Connect Social Accounts")
                                .foregroundStyle(.white.opacity(0.8))
                                .font(.custom("Nunito-Regular", size: 20))
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                                .padding(.bottom, 10)
                        case 4:
                            Text("Submitted")
                                .foregroundStyle(.white.opacity(0.8))
                                .font(.custom("Nunito-Regular", size: 20))
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                                .padding(.bottom, 10)
                        default:
                            Text("")
                                .foregroundStyle(.white.opacity(0.8))
                                .font(.custom("Nunito-Regular", size: 20))
                                .padding(.bottom, 10)
                        }
                    }.padding(.horizontal)
                    Spacer()
                }

                //description, step indicator, progress bar
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text("Step \(vm.step) of 4")
                            .foregroundStyle(.white.opacity(0.5))
                            .font(.custom("Montserrat-Regular", size: 12))
                        Spacer()
                    }
                    HStack(spacing: 5) {
                        ForEach(1...4, id: \.self) { step in
                            Rectangle()
                                .frame(height: 5)
                                .foregroundStyle(vm.step >= step ? .white : .gray.opacity(0.2))
                        }
                    }
                }.padding(.bottom)
                
                //content
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        switch vm.step {
                        case 1:
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Ready to become a creator?")
                                    .foregroundStyle(.white)
                                    .font(.custom("Montserrat-Regular", size: 21))
                                Text("Join our creator program and unlock powerful features to grow your business.")
                                    .multilineTextAlignment(.leading)
                                    .foregroundStyle(.gray)
                                    .font(.custom("Montserrat-Regular", size: 15))
                                    .padding(.bottom, 15)
                            }
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(.white)
                                    Image(systemName: "calendar")
                                        .foregroundStyle(.black)
                                        .imageScale(.medium)
                                        .padding(10)
                                }.fixedSize()
                                VStack(alignment: .leading) {
                                    Text("Create Meetings")
                                        .foregroundStyle(.white)
                                        .font(.custom("Montserrat-Regular", size: 15))
                                    Text("Create custom meeting slots for your services and expertise")
                                        .multilineTextAlignment(.leading)
                                        .foregroundStyle(.gray)
                                        .font(.custom("Montserrat-Regular", size: 13))
                                }
                            }.padding(.vertical, 10)
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(.white)
                                    Image(systemName: "person.2")
                                        .foregroundStyle(.black)
                                        .imageScale(.medium)
                                        .padding(10)
                                }.fixedSize()
                                VStack(alignment: .leading) {
                                    Text("Build Your Audience")
                                        .foregroundStyle(.white)
                                        .font(.custom("Montserrat-Regular", size: 15))
                                    Text("Connect with fans and clients who value your expertise")
                                        .multilineTextAlignment(.leading)
                                        .foregroundStyle(.gray)
                                        .font(.custom("Montserrat-Regular", size: 13))
                                }
                            }.padding(.vertical, 10)
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(.white)
                                    Image(systemName: "arrow.up.right")
                                        .foregroundStyle(.black)
                                        .imageScale(.medium)
                                        .padding(10)
                                    //                                Image(systemName: "chart.line.uptrend.xyaxis").foregroundStyle(.black).imageScale(.large).padding(10)
                                }.fixedSize()
                                VStack(alignment: .leading) {
                                    Text("Monetize Your Time")
                                        .foregroundStyle(.white)
                                        .font(.custom("Montserrat-Regular", size: 15))
                                    Text("Set your own rates and get paid for your valuable time")
                                        .multilineTextAlignment(.leading)
                                        .foregroundStyle(.gray)
                                        .font(.custom("Montserrat-Regular", size: 13))
                                }
                            }.padding(.vertical, 10)
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(.white)
                                    Image(systemName: "star")
                                        .foregroundStyle(.black)
                                        .imageScale(.medium)
                                        .padding(10)
                                }.fixedSize()
                                VStack(alignment: .leading) {
                                    Text("Creator Badge")
                                        .foregroundStyle(.white)
                                        .font(.custom("Montserrat-Regular", size: 15))
                                    Text("Get verified with a special creator badge on your profile")
                                        .multilineTextAlignment(.leading)
                                        .foregroundStyle(.gray)
                                        .font(.custom("Montserrat-Regular", size: 13))
                                }
                            }.padding(.vertical, 10)
                            ZStack {
                                RoundedRectangle(cornerRadius: 10).fill(Color(uiColor: .darkGray))
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Application Process")
                                            .foregroundStyle(.white)
                                            .font(.custom("Montserrat-Regular", size: 14))
                                        HStack(spacing: 5) {
                                            Circle()
                                                .fill(.white)
                                                .frame(width: 5, height: 5)
                                            Text("Review creator benefits")
                                                .foregroundStyle(.white.opacity(0.65))
                                                .font(.custom("Montserrat-Regular", size: 12))
                                        }
                                        HStack(spacing: 5) {
                                            Circle()
                                                .fill(.white)
                                                .frame(width: 5, height: 5)
                                            Text("Accept terms and conditions")
                                                .foregroundStyle(.white.opacity(0.65))
                                                .font(.custom("Montserrat-Regular", size: 12))
                                        }
                                        HStack(spacing: 5) {
                                            Circle()
                                                .fill(.white)
                                                .frame(width: 5, height: 5)
                                            Text("Submit application for review")
                                                .foregroundStyle(.white.opacity(0.65))
                                                .font(.custom("Montserrat-Regular", size: 12))
                                        }
                                    }
                                    Spacer()
                                }.padding()
                            }
                        case 2:
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Terms & Conditions")
                                    .foregroundStyle(.white)
                                    .font(.custom("Montserrat-Regular", size: 21))
                                Text("Please review and accept the terms and conditions")
                                    .multilineTextAlignment(.leading)
                                    .foregroundStyle(.gray)
                                    .font(.custom("Montserrat-Regular", size: 15))
                                    .padding(.bottom, 15)
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(uiColor: .darkGray))
                                    ScrollView {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                //section 1
                                                Text("Creator Responsibilities")
                                                    .foregroundStyle(.white)
                                                    .font(.custom("Montserrat-Regular", size: 14))
                                                HStack(spacing: 5) {
                                                    Circle()
                                                        .fill(.white)
                                                        .frame(width: 5, height: 5)
                                                    Text("Maintain professional conduct")
                                                        .foregroundStyle(.white.opacity(0.65))
                                                        .font(.custom("Montserrat-Regular", size: 12))
                                                }
                                                HStack(spacing: 5) {
                                                    Circle()
                                                        .fill(.white)
                                                        .frame(width: 5, height: 5)
                                                    Text("Provide quality services")
                                                        .foregroundStyle(.white.opacity(0.65))
                                                        .font(.custom("Montserrat-Regular", size: 12))
                                                }
                                                HStack(spacing: 5) {
                                                    Circle()
                                                        .fill(.white)
                                                        .frame(width: 5, height: 5)
                                                    Text("Respond to bookings accordingly")
                                                        .foregroundStyle(.white.opacity(0.65))
                                                        .font(.custom("Montserrat-Regular", size: 12))
                                                }
                                                HStack(spacing: 5) {
                                                    Circle()
                                                        .fill(.white)
                                                        .frame(width: 5, height: 5)
                                                    Text("Comply with platform guidelines")
                                                        .foregroundStyle(.white.opacity(0.65))
                                                        .font(.custom("Montserrat-Regular", size: 12))
                                                }
                                                //section 2
                                                Text("Creator Rights")
                                                    .foregroundStyle(.white)
                                                    .font(.custom("Montserrat-Regular", size: 14))
                                                    .padding(.top, 10)
                                                HStack(spacing: 5) {
                                                    Circle()
                                                        .fill(.white)
                                                        .frame(width: 5, height: 5)
                                                    Text("Set your own rates")
                                                        .foregroundStyle(.white.opacity(0.65))
                                                        .font(.custom("Montserrat-Regular", size: 12))
                                                }
                                                HStack(spacing: 5) {
                                                    Circle()
                                                        .fill(.white)
                                                        .frame(width: 5, height: 5)
                                                    Text("Manage your availability")
                                                        .foregroundStyle(.white.opacity(0.65))
                                                        .font(.custom("Montserrat-Regular", size: 12))
                                                }
                                                HStack(spacing: 5) {
                                                    Circle()
                                                        .fill(.white)
                                                        .frame(width: 5, height: 5)
                                                    Text("Control event types")
                                                        .foregroundStyle(.white.opacity(0.65))
                                                        .font(.custom("Montserrat-Regular", size: 12))
                                                }
                                                HStack(spacing: 5) {
                                                    Circle()
                                                        .fill(.white)
                                                        .frame(width: 5, height: 5)
                                                    Text("Access creator features")
                                                        .foregroundStyle(.white.opacity(0.65))
                                                        .font(.custom("Montserrat-Regular", size: 12))
                                                }
                                                //section 3
                                                Text("Platform Policies")
                                                    .foregroundStyle(.white)
                                                    .font(.custom("Montserrat-Regular", size: 14))
                                                    .padding(.top, 10)
                                                HStack(spacing: 5) {
                                                    Circle()
                                                        .fill(.white)
                                                        .frame(width: 5, height: 5)
                                                    Text("No harmful content")
                                                        .foregroundStyle(.white.opacity(0.65))
                                                        .font(.custom("Montserrat-Regular", size: 12))
                                                }
                                                HStack(spacing: 5) {
                                                    Circle()
                                                        .fill(.white)
                                                        .frame(width: 5, height: 5)
                                                    Text("Respect user privacy")
                                                        .foregroundStyle(.white.opacity(0.65))
                                                        .font(.custom("Montserrat-Regular", size: 12))
                                                }
                                                HStack(spacing: 5) {
                                                    Circle()
                                                        .fill(.white)
                                                        .frame(width: 5, height: 5)
                                                    Text("Accurate service descriptions")
                                                        .foregroundStyle(.white.opacity(0.65))
                                                        .font(.custom("Montserrat-Regular", size: 12))
                                                }
                                                HStack(spacing: 5) {
                                                    Circle()
                                                        .fill(.white)
                                                        .frame(width: 5, height: 5)
                                                    Text("Prompt communication")
                                                        .foregroundStyle(.white.opacity(0.65))
                                                        .font(.custom("Montserrat-Regular", size: 12))
                                                }
                                            }
                                            Spacer()
                                        }.padding()
                                    }
                                        
                                }
                            }
                        case 3:
                            Text("Link your social media profiles to build trust with your audience and showcase your creator presence.")
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(.gray)
                                .font(.custom("Montserrat-Regular", size: 16))
                                .padding(.bottom, 15)
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(uiColor: .darkGray))
                                HStack {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Why connect social accounts?")
                                            .foregroundStyle(.white).font(.custom("Montserrat-Regular", size: 18))
                                        HStack(spacing: 5) {
                                            Circle()
                                                .fill(.white)
                                                .frame(width: 5, height: 5)
                                            Text("Verify your creator identity and authenticity")
                                                .foregroundStyle(.white.opacity(0.65))
                                                .font(.custom("Montserrat-Regular", size: 12))
                                        }
                                        HStack(spacing: 5) {
                                            Circle()
                                                .fill(.white)
                                                .frame(width: 5, height: 5)
                                            Text("Verify your creator identity and authenticity")
                                                .foregroundStyle(.white.opacity(0.65))
                                                .font(.custom("Montserrat-Regular", size: 12))
                                        }
                                        HStack(spacing: 5) {
                                            Circle()
                                                .fill(.white)
                                                .frame(width: 5, height: 5)
                                            Text("Build trust and credibility with your audience")
                                                .foregroundStyle(.white.opacity(0.65))
                                                .font(.custom("Montserrat-Regular", size: 12))
                                        }
                                        HStack(spacing: 5) {
                                            Circle()
                                                .fill(.white)
                                                .frame(width: 5, height: 5)
                                            Text("Showcase your social media presence and following")
                                                .foregroundStyle(.white.opacity(0.65))
                                                .font(.custom("Montserrat-Regular", size: 12))
                                        }
                                    }.padding()
                                    Spacer()
                                }
                            }
                            Text("Available Platforms")
                                .foregroundStyle(.white)
                                .font(.custom("Montserrat-Regular", size: 20))
                                .padding(.vertical, 5)
                            ForEach(0..<vm.platforms.count, id: \.self) { index in

                                let platformKey = vm.platforms[index].lowercased()

                                let accountBinding = Binding<ConnectedSocialMediaAccountForVerify?>(
                                    get: {
                                        vm.connectedAccounts.first { act in
                                            (vm.getAccountPlatformFromID(platformId: act.social_media_platform_id ?? 0)) == platformKey
                                        }
                                    },
                                    set: { newValue in
                                        vm.connectedAccounts.removeAll { act in
                                            (vm.getAccountPlatformFromID(platformId: act.social_media_platform_id ?? 0)) == platformKey
                                        }
                                        if let newValue {
                                            vm.connectedAccounts.append(newValue)
                                        }
                                    }
                                )
                                
                                if vm.platforms[index] != "Twitter" {
                                    SocialConnectButton(vm: vm, platform: vm.platforms[index], image: vm.images[index], connectedAccount: accountBinding, action: {
                                        Task {
                                            print("platform requested: \(vm.platforms[index].lowercased())")
                                            try await vm.startVerification(platform: vm.platforms[index])
                                            //                                        try await vm.testPlatformURL(platform: vm.platforms[index])
                                        }
                                    }, remove: { accountId in
                                        print("remove account \(accountId)")
                                    })
                                }
//                                .overlay(alignment: .topLeading) {
//                                    Button {
//                                        print("requested remove account \(accountBinding?.id ?? 0)")
//                                    } label: {
//                                        Image(systemName: "xmark.circle.fill")
//                                            .symbolRenderingMode(.palette)
//                                            .foregroundStyle(.red, .white)
//                                            .imageScale(.large)
//                                    }.offset(x: -10, y: 10)
//                                }
                            }
                        case 4:
                            VStack(alignment: .center, spacing: 5) {
                                Image(systemName: "clock.badge.fill")
                                    .foregroundStyle(.orange)
                                    .font(.title)
                                    .bold()
                                    .padding(10)
                                Text("Application Submitted")
                                    .foregroundStyle(.white)
                                    .font(.custom("Montserrat-Regular", size: 24))
                                Text("Application Under Review")
                                    .foregroundStyle(.gray)
                                    .font(.custom("Montserrat-Regular", size: 19))
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.orange)
                                    VStack(spacing: 8) {
                                        Text("Review in Progress")
                                            .foregroundStyle(.white)
                                            .font(.custom("Montserrat-Bold", size: 18))
                                        Text("We're reviewing your application and will get back to you soon")
                                            .foregroundStyle(.white.opacity(0.75))
                                            .font(.custom("Montserrat-Regular", size: 16))
                                    }.padding()
                                }.fixedSize(horizontal: false, vertical: true).padding()
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.gray)
                                    VStack(spacing: 8) {
                                        Text("What happens next?")
                                            .foregroundStyle(.white)
                                            .font(.custom("Montserrat-Regular", size: 19))
                                        HStack {
                                            Image(systemName: "clock")
                                                .foregroundStyle(.white)
                                                .opacity(0.7).imageScale(.medium)
                                            Text("An admin will review your application")
                                                .foregroundStyle(.white)
                                                .opacity(0.7)
                                                .font(.custom("Montserrat-Regular", size: 14))
                                            Spacer()
                                        }
                                        // TODO -> is this true?
//                                        HStack {
//                                            Image(systemName: "checkmark.circle")
//                                                .foregroundStyle(.white)
//                                                .opacity(0.7)
//                                                .imageScale(.medium)
//                                            Text("You will be notified via email")
//                                                .foregroundStyle(.white)
//                                                .opacity(0.7)
//                                                .font(.custom("Montserrat-Regular", size: 14))
//                                            Spacer()
//                                        }
                                        HStack {
                                            Image(systemName: "checkmark.circle")
                                                .foregroundStyle(.white)
                                                .opacity(0.7)
                                                .imageScale(.medium)
                                            Text("Review usually takes 24-48 hours")
                                                .foregroundStyle(.white)
                                                .opacity(0.7)
                                                .font(.custom("Montserrat-Regular", size: 14))
                                            Spacer()
                                        }
                                    }.padding()
                                }.fixedSize(horizontal: false, vertical: true).padding()
                                Button { dismiss() } label: {
                                    Text("Return to dashboard")
                                        .foregroundStyle(.white)
                                        .font(.custom("Montserrat-Regular", size: 21))
                                }.padding()
//                                Divider()
//                                Text("Application ID: \(vm.myCreatorRequest?.request?.id ?? 0)").foregroundStyle(.gray).font(.custom("Inter", size: 15)).padding(.top, 12)
//                                Text("Submitted on: \(mmddyyyy(getDateNoTimezone(date: vm.myCreatorRequest?.request?.submittedAt ?? "", withMS: true)))")
//                                    .foregroundStyle(.gray)
//                                    .font(.custom("Inter", size: 15))
                            }
                        default:
                            Text("")
                        }
                    }
                }
                Spacer()
                //action buttons
                if (vm.step == 2) {
                    HStack {
                        Button { vm.acceptTerms.toggle() } label: {
                            HStack {
                                Image(systemName: vm.acceptTerms ? "checkmark.square" : "square")
                                    .foregroundStyle(.gray)
                                    .imageScale(.large)
                                Text("I accept the terms and conditions")
                                    .foregroundStyle(.white)
                                    .font(.custom("Nunito-Regular", size: 16))
                                    .lineLimit(1)
                        
                            }
                        }
                        Spacer()
                    }.padding(.horizontal).padding(.bottom)
                }
                if (vm.step != 4) {
                    HStack {
                        if (vm.step > 1) {
                            Button { vm.step -= 1 } label: {
                                Text("Back")
                                    .foregroundStyle(.white)
                                    .font(.custom("Nunito-Regular", size: 15))
                            }.disabled(vm.isLoading)
                        }
                        Spacer()
                        Button {
                            if vm.step < 3 { vm.step += 1 }
                            else { Task { try await vm.submitApplication() } }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill((vm.step == 3 && vm.connectedAccounts.isEmpty) || (vm.step == 2 && !vm.acceptTerms) ? .gray : .white)
                                if vm.isLoading {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .imageScale(.large)
                                        .tint(.gray)
                                        .padding(10)
                                } else {
                                    Text(vm.step == 3 ? "Submit Application" : "Continue")
//                                        .foregroundStyle(vm.step == 3 /*&& vm.connectedAccounts.isEmpty*/ ? .white : .black)
                                        .foregroundStyle(.black)
                                        .font(.custom("Nunito-Regular", size: 15))
                                        .padding(10)
                                }
                            }
                        }.fixedSize().disabled((vm.step == 2 && !vm.acceptTerms) || vm.isLoading || (vm.step == 3 && vm.connectedAccounts.isEmpty))
                    }.padding()
                }
                //bottom
            }.padding(.top).padding(.horizontal)
        }.navigationBarBackButtonHidden()
            .onAppear {
                Task {
                    do {
                        try await vm.getConnectedAccounts()
                    }
                }
            }
            .alert(vm.errorMsg, isPresented: $vm.showErrorAlert) {
                Button("Ok", role: .cancel) {}
            } message: {
                Text("Please try again.")
            }
    }
    
    func mmddyyyy(_ date: Date?) -> String {
        guard let date else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: date)
    }
}

extension VerifySocialMediaView {
    struct SocialConnectButton: View {
        
        @ObservedObject var vm: VerifySocialMediaVM
        
        var platform: String
        var image: String
        
        //MARK: this doesnt get updated after changing because it isnt being passed in as binding
        @Binding var connectedAccount: ConnectedSocialMediaAccountForVerify?
        
        let action: () -> Void
        
        let remove: (_ accountId: Int) -> Void
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.clear)
                    .stroke(.white, lineWidth: 0.5)
                if (connectedAccount?.id ?? 0) != 0 {
                    VStack {
                        HStack {
                            AsyncImage(url: URL(string: connectedAccount?.profile_picture_url ?? "")) { image in
                                image
                                    .image?
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            }
                            VStack(alignment: .leading, spacing: 5) {
                                Text(connectedAccount?.name ?? "")
                                    .foregroundStyle(.white)
                                    .font(.custom("Montserrat-Regular", size: 17))
                                    .multilineTextAlignment(.leading)
                                Text("@\(connectedAccount?.username ?? "")")
                                    .foregroundStyle(.gray)
                                    .font(.custom("Montserrat-Regular", size: 15))
                                    .multilineTextAlignment(.leading)
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 7) {
                                Text(platform)
                                    .foregroundStyle(.white)
                                    .font(.custom("Montserrat-Regular", size: 17))
                                    .multilineTextAlignment(.trailing)
                                Text("\(connectedAccount?.followers_count ?? 0) followers")
                                    .foregroundStyle(.gray)
                                    .font(.custom("Montserrat-Regular", size: 14)).multilineTextAlignment(.trailing)
                            }
                        }
                        Text("Connected")
                            .foregroundStyle(.white)
                            .font(.custom("Montserrat-Regular", size: 16))
                    }.padding()
                } else {
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(platform)
                                .foregroundStyle(.white)
                                .font(.custom("Montserrat-Regular", size: 16))
                            
                            Image("\(image)")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding(5)
                                .shadow(color: .white.opacity(0.5), radius: 4)
                        }
                        Spacer()
                        Button { action() } label: {
                            Text("Connect \(platform)")
                                .foregroundStyle(.white)
                                .font(.custom("Montserrat-Regular", size: 16))
                        }
                    }.padding()
                }
            }.onOpenURL { url in
                print("Received url: \(url)")
                if url.absoluteString.contains("callback_failed") {
                    vm.errorMsg = "Link account failed"
                    vm.showErrorAlert = true
                } else {
                    Task { try await vm.getConnectedAccounts() } //refetch accounts if no issue
                }
            }
//            .overlay(alignment: .topLeading) {
//                if let accountId = connectedAccount?.id, accountId != 0 {
//                    Button {
//                        remove(accountId)
//                    } label: {
//                        Image(systemName: "xmark.circle.fill")
//                            .symbolRenderingMode(.palette)
//                            .foregroundStyle(.red, .white)
//                            .imageScale(.large)
//                    }.offset(x: -10, y: 10)
//                }
//            }
        }
    }
}

#Preview {
    VerifySocialMediaView()
}


