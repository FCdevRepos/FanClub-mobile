//
//  DiscoverView.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 9/10/24.
//

import SwiftUI

struct DiscoverView: View {
    
    @StateObject var vm = DiscoverVM()
    
    @State var loading = false
    @State var rotationAngle = 0.0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color
                    .black.opacity(0.92)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Search for your favorite")
                                .foregroundStyle(.white)
                                .font(.title2)
                            Text("Creators and Communities")
                                .foregroundStyle(.yellow)
                                .font(.title2)
                        }
                        Spacer()
                        Menu {
                            Button {vm.tagFilter="All"} label: {
                                Text("All")
                                if vm.tagFilter == "All" {
                                    Image(systemName: "checkmark")
                                }
                            }
//                            ForEach(GlobalVars.creatorCategories, id: \.self) { cat in
                            ForEach(vm.activeTags, id: \.self) { tag in
                                HStack {
                                    Button {vm.tagFilter = tag} label: {
                                        Text(tag)
                                        if vm.tagFilter == tag {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            Image("Filter")
                        }
                    }.padding()
                    //MARK: do we really need a separate page for this?
//                    NavigationLink {SearchExpandedView()} label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.white.opacity(0.4), lineWidth: 0.5)
                            .fill(.clear)
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .imageScale(.large)
                                .foregroundStyle(.white)
                            TextField("", text: $vm.searchTerm, prompt: Text("Search for Creators").foregroundStyle(.white.opacity(0.5)))
                                .foregroundStyle(.white)
                                .font(.subheadline)
                                .textInputAutocapitalization(.words)
                                .autocorrectionDisabled()
                            
//                            Text("Search for Creators")
//                                .foregroundStyle(.white)
//                                .opacity(0.7)
//                                .multilineTextAlignment(.leading)
//                                .font(.subheadline)
                            Spacer()
                        }.padding(12)
                    }.fixedSize(horizontal: false, vertical: true).padding(.horizontal)
//                    }
                    ScrollView {
                        LazyVGrid(columns: [GridItem(), GridItem()]) {
                            ForEach(vm.displayedCreators, id: \.self) { creator in
                                CreatorBox(creator: creator, onAdd: {
                                    print("added creator \(creator.name ?? "")")
                                }, onBook: {
                                    print("booked creator \(creator.name ?? "")")
                                }).padding()
                            }
                        }
                    }.refreshable { vm.createTestData() }.onTapGesture { hideKeyboard() }
                }
            }
        }.navigationBarBackButtonHidden()
            .disabled(loading)
            .overlay {
                if loading {
                    ZStack {
                        Color.black.opacity(0.25).ignoresSafeArea()
                        Image("Loading")
                            .rotationEffect(Angle(degrees: rotationAngle))
                            .onAppear {
                                // Start the spinning animation
                                withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                                    rotationAngle = 360 // Spin for a full rotation
                                }
                            }
                    }
                }
            }
            .onAppear {
                rotationAngle = 0
                vm.createTestData()
            }
            .onChange(of: vm.tagFilter) {
//                vm.updateTagFilter()
                vm.filterCreators()
            }
            .onChange(of: vm.searchTerm) {
//                vm.updateSearch()
                vm.filterCreators()
            }
    }
}

struct CreatorBox: View {
    
    let bgColor = Color(red: 42/255, green: 42/255, blue: 42/255)
    let bottomBgColor = Color(red: 65/255, green: 65/255, blue: 65/255)
    let nameColor = Color(red: 160/255, green: 99/255, blue: 215/255)
    
    var creator: Creator
    
    let onAdd: () -> Void
    
    let onBook: () -> Void
    
    @State var imageResource: ImageResource = .man
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8).fill(bgColor)
            VStack(spacing: 8) {
                Image(imageResource)
                    .resizable()
                    .frame(width: 82, height: 60)
                    .clipShape(Circle())
                    .overlay(alignment: .bottom) {
                        Button { onAdd() } label: {
                            ZStack {
                                Circle()
                                    .fill(bottomBgColor)
                                Image(systemName: "plus")
                                    .foregroundStyle(.white)
                                    .imageScale(.small).padding(3)
                            }
                        }
                        .fixedSize()
                        .offset(y: 15)
                    }
                .padding(.vertical)
                Text(creator.name ?? "")
                    .foregroundStyle(nameColor)
                    .font(.custom("Montserrat-SemiBold", size: 16))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                if (creator.tags ?? []).count == 1 {
                    Text("\((creator.tags ?? [])[0])")
                        .foregroundStyle(.white.opacity(0.9))
                        .font(.custom("Montserrat-Regular", size: 12))
                        .lineLimit(1)
                } else {
                    Text("\((creator.tags ?? [])[0]), +\((creator.tags ?? []).count - 1)")
                        .foregroundStyle(.white.opacity(0.9))
                        .font(.custom("Montserrat-Regular", size: 12))
                        .lineLimit(1)
                }
                Text("\(creator.fans ?? 0) fans")
                    .foregroundStyle(.white.opacity(0.9))
                    .font(.custom("Montserrat-Regular", size: 12))
                //TODO: sometimes last view is not anchord to bottom of overarching zstack
//                NavigationLink {} label: {
//                Button { onBook() } label: {
                NavigationLink { BookMeetingView(creator: creator) } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(bottomBgColor)
                        Text("Book time to meet")
                            .foregroundStyle(.white)
                            .font(.custom("Montserrat-Regular", size: 14))
                            .padding(.vertical, 10).lineLimit(1)
                    }
                }.fixedSize(horizontal: false, vertical: true)
            }
        }.onAppear {
            let rand = Int.random(in: 1...2)
            if rand == 1 {
                imageResource = .man
            } else {
                imageResource = .woman
            }
        }
    }
}

#Preview {
    DiscoverView()
}
