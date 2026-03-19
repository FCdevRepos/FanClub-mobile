//
//  SearchExpandedView.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 9/11/24.
//

import SwiftUI

struct SearchExpandedView: View {
    @Environment(\.presentationMode) var pm
    
    @State var search = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.opacity(0.88).ignoresSafeArea()
                VStack {
                    HStack {
                        Button {pm.wrappedValue.dismiss()} label: {
                            Image(systemName: "chevron.left").imageScale(.large).foregroundStyle(.white)
                        }
                        ZStack {
                            RoundedRectangle(cornerRadius: 10).stroke(.white.opacity(0.4), lineWidth: 0.5).fill(.clear)
                            HStack {
                                Image(systemName: "magnifyingglass").imageScale(.large).foregroundStyle(.white)
                                TextField("", text: $search).foregroundStyle(.white).multilineTextAlignment(.leading)
                                    .overlay(alignment: .leading) {
                                        if search.isEmpty {
                                            Text("Search for Creators").foregroundStyle(.white).opacity(0.7).multilineTextAlignment(.leading).font(.subheadline).allowsHitTesting(false)
                                        }
                                    }
                                Spacer()
                            }.padding(12)
                        }.fixedSize(horizontal: false, vertical: true).padding(.horizontal)
                    }.padding(.leading).padding(.vertical, 10)
                    Spacer()
                }
            }
        }.navigationBarBackButtonHidden().tint(.white)
    }
}

#Preview {
    SearchExpandedView()
}
