//
//  HomeView.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 9/10/24.
//

import SwiftUI

struct HomeView: View {
    
    @State var posts: [String] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.opacity(0.7).ignoresSafeArea()
                VStack {
                    HStack {
                        Text("Home").foregroundStyle(GlobalVars.textColor).font(.title2)
                        Spacer()
                        Image("footer_logo").resizable().frame(width: 100, height: 100).brightness(0.175)
                        Spacer()
                        NavigationLink {NotificationsView()} label: {
                            Image(systemName: "bell").foregroundStyle(.white).imageScale(.large).padding(.leading)
                        }
                    }.padding(.horizontal).frame(maxHeight: 70)
                    Spacer()
                    if posts.isEmpty {
                        Text("No posts are available").foregroundStyle(GlobalVars.textColor).font(.title2)
                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
