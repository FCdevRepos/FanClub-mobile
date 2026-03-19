//
//  MessagesView.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 9/11/24.
//

import SwiftUI

struct MessagesView: View {
    @Environment(\.presentationMode) var pm
    var msg: [String] = []
    
    @State var search = ""
    @State var tab = "p"
    @State var requestTab = "s"
        
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.opacity(0.88).ignoresSafeArea()
                VStack {
                    HStack {
                        Button {pm.wrappedValue.dismiss()} label: {
                            Image(systemName: "chevron.left").imageScale(.large).foregroundStyle(.white)
                        }
                        Text("Messages").foregroundStyle(GlobalVars.textColor).font(.title2).padding(.horizontal)
                        Spacer()
                        Menu {
                            NavigationLink {HiddenMessagesView()} label: {
                                Text("Hidden Chats")
                            }
                        } label: {
                            Image(systemName: "ellipsis").imageScale(.large).rotationEffect(Angle(degrees: 90)).foregroundStyle(.white)
                        }
                    }.padding(.horizontal).frame(maxHeight: 70)
                    ZStack {
                        RoundedRectangle(cornerRadius: 10).stroke(.white.opacity(0.6), lineWidth: 1.2).fill(.clear)
                        HStack {
                            Image(systemName: "magnifyingglass").imageScale(.large).foregroundStyle(.white)
                            TextField("", text: $search).foregroundStyle(.white).multilineTextAlignment(.leading)
                                .overlay(alignment: .leading) {
                                    if search.isEmpty {
                                        Text("Search users").foregroundStyle(.gray).multilineTextAlignment(.leading).allowsHitTesting(false)
                                    }
                                }
                            Spacer()
                        }.padding(12)
                    }.fixedSize(horizontal: false, vertical: true).padding(.horizontal)
                    HStack {
                        Button {tab="p"} label: { VStack {
                            Text("Primary").foregroundStyle(tab == "p" ? .white : .gray).bold(tab=="p")
                            if tab == "p" {Rectangle().frame(height: 2).foregroundStyle(.white)} }
                        }.fixedSize()
                        Spacer()
                        Button {tab="g"} label: { VStack {
                            Text("General").foregroundStyle(tab == "g" ? .white : .gray).bold(tab=="g")
                            if tab == "g" {Rectangle().frame(height: 2).foregroundStyle(.white)} }
                        }.fixedSize()
                        Spacer()
                        Button {tab="r"} label: { VStack {
                            Text("Requests").foregroundStyle(Color(uiColor: GlobalVars.purpleColor))
                            if tab == "r" {Rectangle().frame(height: 2).foregroundStyle(Color(uiColor: GlobalVars.purpleColor))} }
                        }.fixedSize()
                    }.padding()
                    if tab == "r" {
                        Picker("", selection: $requestTab) {
                            Text("Send").tag("s")
                            Text("Receive").tag("r")
                        }.pickerStyle(.segmented).padding(.horizontal).padding(.bottom)
                    }
                    Spacer()
                    ZStack {
                        Color.black
                        VStack {
                            if msg.isEmpty {
                                VStack(spacing: 15) {
                                    Spacer()
                                    Image("Messages")
                                    if tab == "p" {
                                        Text("Your Primary Messages").foregroundStyle(.white).font(.title2).bold()
                                        Button {tab="r"} label: {
                                            Text("Go to Message Requests").foregroundStyle(.yellow).font(.headline).opacity(0.8)
                                        }
                                    } else if tab == "g" {
                                        Text("Your General Messages").foregroundStyle(.white).font(.title2).bold()
                                        Text("General messages are those conversations that happen between users you aren't following. If you get a message request and you accept it then those messages will be shown here.").foregroundStyle(.white).font(.footnote).multilineTextAlignment(.center)
                                        Button {tab="r"} label: {
                                            Text("Go to Message Requests").foregroundStyle(.yellow).font(.headline).opacity(0.8)
                                        }
                                    } else {
                                        Text("Your Message Requests").foregroundStyle(.white).font(.title2).bold()
                                    }
                                    Spacer()
                                }.padding(.horizontal, 10)
                            } else {
                                
                            }
                        }
                    }
                }
            }
        }.navigationBarBackButtonHidden().tint(.white).ignoresSafeArea(.keyboard)
        //.onTapGesture {hideKeyboard()} -> cant do this with segmented picker
    }
}

struct HiddenMessagesView: View {
    @Environment(\.presentationMode) var pm
    var hidden: [String] = []
    
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
                        Text("Messages").foregroundStyle(GlobalVars.textColor).font(.title2).padding(.horizontal)
                        Spacer()
                    }.padding(.horizontal).frame(maxHeight: 70)
                    ZStack {
                        RoundedRectangle(cornerRadius: 10).stroke(.white.opacity(0.6), lineWidth: 1.2).fill(.clear)
                        HStack {
                            Image(systemName: "magnifyingglass").imageScale(.large).foregroundStyle(.white)
                            TextField("", text: $search).foregroundStyle(.white).multilineTextAlignment(.leading)
                                .overlay(alignment: .leading) {
                                    if search.isEmpty {
                                        Text("Search users").foregroundStyle(.gray).multilineTextAlignment(.leading).allowsHitTesting(false)
                                    }
                                }
                            Spacer()
                        }.padding(12)
                    }.fixedSize(horizontal: false, vertical: true).padding(.horizontal)
                    if hidden.isEmpty {
                        Spacer()
                        Text("You currently don't have any hidden messages").foregroundStyle(GlobalVars.textColor).font(.title3).multilineTextAlignment(.center)
                        Spacer()
                    } else {
                        ScrollView {
                            
                        }
                    }
                }
            }
        }.navigationBarBackButtonHidden().tint(.white).ignoresSafeArea(.keyboard)
    }
}

#Preview {
    MessagesView()
}
