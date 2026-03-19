//
//  NotificationsView.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 9/10/24.
//

import SwiftUI

struct NotificationsView: View {
    @Environment(\.presentationMode) var pm
    
    @State var notifs: [String] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.opacity(0.88).ignoresSafeArea()
                VStack {
                    HStack {
                        Button {pm.wrappedValue.dismiss()} label: {
                            Image(systemName: "chevron.left").imageScale(.large).foregroundStyle(.white)
                        }
                        Text("Notifications").foregroundStyle(GlobalVars.textColor).font(.title2).padding(.horizontal)
                        Spacer()
                        if !notifs.isEmpty {
                            Button {} label: {
                                //                            Image(systemName: "xmark.circle").imageScale(.large).foregroundStyle(.yellow)
                                Text("Clear").foregroundStyle(.yellow)
                            }
                        }
                    }.padding(.horizontal).frame(maxHeight: 70)
                    if notifs.isEmpty {
                        Spacer()
                        Text("No notifications found").foregroundStyle(GlobalVars.textColor).font(.title3)
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
