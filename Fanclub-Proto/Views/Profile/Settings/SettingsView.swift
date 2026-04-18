//
//  SettingsView.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 9/11/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("auth") var auth = false
    @AppStorage("userId") var userId = 0
    
    @State var popup = false
    @State var popupItem: [String] = []
    
    let grayColor = Color(red: 70/255, green: 70/255, blue: 70/255)
    
    @State var yDragOffset = 0.0
    @GestureState var location = CGPoint(x: 0, y: 0)
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.opacity(0.88).ignoresSafeArea()
                VStack {
                    HStack {
                        Button { dismiss() } label: {
                            Image(systemName: "chevron.left").imageScale(.large).foregroundStyle(.white)
                        }
                        Text("Settings").foregroundStyle(GlobalVars.textColor).font(.title2).padding(.horizontal)
                        Spacer()
                    }.padding(.horizontal).frame(maxHeight: 70)
                    //MARK: sections
                    ScrollView {
                        Group {
                            ForEach(GlobalVars.SettingsLinks, id: \.self) { group in
                                VStack {
                                    if group[1] == "Page" {
                                        NavigationLink {} label: {
                                            ListItem(text: group[0], color: group[3], logout: false, delete: false)
                                        }.padding(.vertical)
                                    } else if group[1] == "Popup" {
                                        Button {withAnimation{popup = true; popupItem = group} } label: {
                                            ListItem(text: group[0], color: group[3], logout: false, delete: false)
                                        }.padding(.vertical)
                                    } else if group[1] == "Webpage" {
                                        ListItem(text: group[0], color: group[3], logout: false, delete: false).padding(.vertical)
                                    } else if group[1] == "Email" {
                                        ListItem(text: group[0], color: group[3], logout: false, delete: false).padding(.vertical)
                                    } else if group[2] == "logout" {//action logout
                                        ListButton(text: group[0], color: group[3], logout: true, delete: false).padding(.vertical)
                                    } else if group[2] == "delete" {
                                        ListButton(text: group[0], color: group[3], logout: false, delete: true).padding(.vertical)
                                    } else {//
                                        ListItem(text: group[0], color: group[3], logout: false, delete: false).padding(.vertical)
                                    }
                                    Rectangle().frame(height: 0.4).foregroundStyle(.gray.opacity(0.4))
                                }.padding(.horizontal)
                            }
                        }
                    }
                }
            }
        }.navigationBarBackButtonHidden()
            .disabled(popup)
            .overlay {
                if popup {
                    VStack {
                        Color.clear.frame(height: UIScreen.main.bounds.height * 0.3).contentShape(Rectangle()).onTapGesture {
                            withAnimation{popup = false ; popupItem = []}
                        }
                        Spacer()
                        ZStack {
                            grayColor
                            VStack {
                                Rectangle().frame(width: 100, height: 2).foregroundStyle(.white).padding()
                                //other stuff here
                                Spacer()
                                if popupItem[2] == "club_coins" { ClubCoinsPopup() }
                                else if popupItem[2] == "invite_code_share" { InviteCodeSharePopup() }
                                else if popupItem[2] == "profile_link" {  ProfileLinkPopup() }
                                else if popupItem[2] == "payouts" { PayoutsPopup() }
                            }
                        }.offset(y: -1 * yDragOffset)//.frame(height: UIScreen.main.bounds.height / 2)
                    }.transition(.move(edge: .bottom)).edgesIgnoringSafeArea(.bottom)
                        .gesture(
                            DragGesture().updating($location, body: { (value, gestureState, transaction) in
                                yDragOffset = location.y
                            })
                        )
//                              DragGesture().onEnded { value in
//                                if value.location.y - value.startLocation.y > 150 {
//                                    withAnimation{popup = false ; popupItem = []}
//                                }
//                              }
//                            )
                }
            }
            .toolbar(popup ? .hidden : .visible, for: .tabBar)
    }
    
    
    func ListItem(text: String, color: String, logout: Bool, delete: Bool) -> some View {
    
        return HStack {
            Text(text).foregroundStyle(color == "" ? GlobalVars.textColor : getColor(color: color)).font(.title3)
            Spacer()
        }
        
        func getColor(color: String) -> Color {
            if color == "red" { return .red }
            else if color == "yellow" { return .yellow }
            else { return .white }
        }
    }
    
    func ListButton(text: String, color: String, logout: Bool, delete: Bool) -> some View {
        return Button {
            if logout { //logout
                print("logging out")
                auth = false
                userId = 0
                dismiss()
                //logout user via API endpoint?
            } else { //delete account
                print("deleting account")
            }
        } label: {
                HStack {
                    Text(text).foregroundStyle(color == "" ? GlobalVars.textColor : getColor(color: color)).font(.title3)
                    Spacer()
            }
        }
        
        func getColor(color: String) -> Color {
            if color == "red" { return .red }
            else if color == "yellow" { return .yellow }
            else { return .white }
        }
    }
    
    
//    var PopupContent: some View {
//        switch popupItem[2] {
//        case "club_coins":
//            ClubCoinsPopup
//        case "invite_code_share":
//            InviteCodeSharePopup()
//        case "profile_link":
//            ProfileLinkPopup()
//        case "payouts":
//            PayoutsPopup()
//        default: EmptyView()
//        }
//    }
}



#Preview {
    SettingsView()
}
