//
//  BookingsView.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 9/10/24.
//

import SwiftUI

struct BookingsView: View {

    @State var meetings: [String] = []
    
    @State var tab = "my"
    
    @State var monthSel = Calendar.current.dateComponents([.month], from: Date.now).month ?? 1
    @State var yearSel = Calendar.current.dateComponents([.year], from: Date.now).year ?? 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.opacity(0.92).ignoresSafeArea()
                VStack {
                    HStack {
                        Text("Meetings").font(.title2).foregroundStyle(GlobalVars.YellowText)
                        Spacer()
                    }.padding()
                    HStack {
                        Button {tab="my"} label: {
                            VStack(spacing: 15) {
                                Text("My Slots").foregroundStyle(.white).font(tab=="my" ? .title2 : .subheadline)
                                if tab == "my" { Rectangle().frame(height: 2).foregroundStyle(Color(uiColor: GlobalVars.purpleColor)) }
                            }
                        }.fixedSize()
                        Spacer()
                        Button {tab="up"} label: {
                            VStack(spacing: 15) {
                                Text("Upcoming").foregroundStyle(.white).font(tab=="up" ? .title2 : .subheadline)
                                if tab == "up" { Rectangle().frame(height: 2).foregroundStyle(Color(uiColor: GlobalVars.purpleColor)) }
                            }
                        }.fixedSize()
                        Spacer()
                        Button {tab="pr"} label: {
                            VStack(spacing: 15) {
                                Text("Previous").foregroundStyle(.white).font(tab=="pr" ? .title2 : .subheadline)
                                if tab == "pr" { Rectangle().frame(height: 2).foregroundStyle(Color(uiColor: GlobalVars.purpleColor)) }
                            }
                        }.fixedSize()
                    }.padding(.horizontal).padding(.vertical, 10)
                    if tab == "my" {
                        HStack {
                            Button {
                                if monthSel == 1 {monthSel = 12; yearSel-=1} else {monthSel -= 1}
                            } label: {
                                Image(systemName: "chevron.left").foregroundStyle(.white).font(.system(size: 12))
                            }.padding(.trailing, 8)
                            Text(Calendar.current.monthSymbols[monthSel - 1]).foregroundStyle(.white)
                            Text("\(String(yearSel))").foregroundStyle(.white)
                            Button {
                                if monthSel == 12 {monthSel = 1; yearSel+=1} else {monthSel += 1}
                            } label: {
                                Image(systemName: "chevron.right").foregroundStyle(.white).font(.system(size: 12))
                            }.padding(.leading, 8)
                            Spacer()
                        }.padding()
                    } else {
                        if meetings.isEmpty {
                            Spacer()

                            Text("You don't have any booked meetings yet").foregroundStyle(.gray).font(.title3).multilineTextAlignment(.center)
                        }
                    }
                    Spacer()
                }
            }
            .overlay(alignment: .bottomTrailing) {
                if tab == "my" {
                    NavigationLink {NewMeetingSlotView()} label: {
                        ZStack {
                            Circle().fill(.yellow)
                            Image(systemName: "plus").foregroundStyle(.black).imageScale(.medium).padding()
                        }
                    }.fixedSize().padding()
                }
            }
        }.navigationBarBackButtonHidden()
    }
}

#Preview {
    BookingsView()
}
