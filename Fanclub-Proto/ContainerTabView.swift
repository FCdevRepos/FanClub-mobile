//
//  ContentView.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 9/10/24.
//

import SwiftUI
import UIKit

struct ContainerTabView: View {
    @Environment(\.presentationMode) var pm
    
    private let profileManager = ProfileManager.shared
    
    @State var tab = "home"
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.92).ignoresSafeArea()
            TabView(selection: $tab) {
//                HomeView().tag("home")
//                    .tabItem {
//                        Image(tab == "home" ? "HomeSel" : "Home")
//                    }.background(Color.black.opacity(0.7).ignoresSafeArea())
                DiscoverView().tag("search")
                    .tabItem {
                        Image(tab == "search" ? "SearchSel" : "Search")
                    }
                if profileManager.profile?.influencer ?? false {
                    SlotsView().tag("bookings")
                        .tabItem {
                            Image(tab == "bookings" ? "CalendarSel" : "Calendar")
                        }
                }
                ProfileView().tag("profile")
                    .tabItem {
                        Image(tab == "profile" ? "ProfileSel" : "Profile")
                    }
            }.tint(.purple)
        }
    }
}

#Preview {
    ContainerTabView()
}
