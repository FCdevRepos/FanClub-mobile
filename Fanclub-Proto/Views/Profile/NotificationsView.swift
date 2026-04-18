//
//  NotificationsView.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 4/2/26.
//
import SwiftUI


struct NotificationsView: View {
    @Environment(\.dismiss) var dismiss
    
    private let profileManager = ProfileManager.shared
    
    @StateObject var vm = NotificationsVM()
    
    @State var notifs: [String] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color
                    .black.opacity(0.92)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Button { dismiss() } label: {
                            Image(systemName: "chevron.left")
                                .imageScale(.large)
                                .foregroundStyle(.white)
                        }
                        Text("Notifications")
                            .foregroundStyle(GlobalVars.textColor)
                            .font(.title2)
                            .padding(.horizontal)
                        Spacer()
                        if !notifs.isEmpty {
                            Button {} label: {
                                //                            Image(systemName: "xmark.circle").imageScale(.large).foregroundStyle(.yellow)
                                Text("Clear")
                                    .foregroundStyle(.yellow)
                            }
                        }
                    }.padding(.horizontal).frame(maxHeight: 70)
                    if notifs.isEmpty {
                        Spacer()
                        Text("No notifications found")
                            .foregroundStyle(GlobalVars.textColor)
                            .font(.title3)
                        Spacer()
                    } else {
                        ScrollView {
                            
                        }
                    }
                }
            }
        }.navigationBarBackButtonHidden()
    }
}

#Preview {
    NotificationsView()
}

