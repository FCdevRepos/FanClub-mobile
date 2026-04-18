//
//  AddPostView.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 9/13/24.
//

import SwiftUI

struct AddPostView: View {
    @Environment(\.presentationMode) var pm
    
    @State var postText = ""
    
    @State var exclusive = false
    @State var subscPriceSet = false
    @State var showAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.opacity(0.88).ignoresSafeArea()
                VStack {
                    HStack {
                        Button {pm.wrappedValue.dismiss()} label: {
                            Image(systemName: "chevron.left").imageScale(.large).foregroundStyle(.white)
                        }
                        Text("Add Post").foregroundStyle(GlobalVars.textColor).font(.title2).padding(.horizontal)
                        Spacer()
                    }.padding()
                    ZStack {
                        RoundedRectangle(cornerRadius: 10).stroke(.gray, lineWidth: 2)
                        TextField("", text: $postText, prompt: Text("Type anything you like......").foregroundStyle(.gray), axis: .vertical).lineLimit(5, reservesSpace: true).foregroundStyle(.white).padding()
                    }.fixedSize(horizontal: false, vertical: true).padding()
                    HStack {
                        Button {} label: {
                            HStack {
                                Image(systemName: "photo").imageScale(.large).foregroundStyle(.yellow)
                                Text("Add Pictures").font(.subheadline).foregroundStyle(.yellow)
                            }
                        }.padding(.trailing)
                        Button {} label: {
                            HStack {
                                Image(systemName: "play.rectangle").imageScale(.large).foregroundStyle(.yellow)
                                Text("Add Video/Music").font(.subheadline).foregroundStyle(.yellow)
                            }
                        }.padding(.leading)
                    }.padding()
                    Spacer()
                    HStack {
                        Text("Exclusive to your Fans.").foregroundStyle(.white).font(.callout).lineLimit(1).minimumScaleFactor(0.6)
                        Button {} label: {
                            Text("Learn more").foregroundStyle(.yellow).font(.footnote)
                        }
                        Spacer()
                        Toggle(isOn: $exclusive) {}.tint(.green)
                    }.padding()
                    Button {} label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15).foregroundStyle(postText == "" ? .gray : Color(uiColor: GlobalVars.purpleColor))
                            Text("Add Post").foregroundStyle(.white).font(.body).padding()
                        }
                    }.fixedSize(horizontal: false, vertical: true).disabled(postText == "").padding().frame(width: UIScreen.main.bounds.width / 2)
                }
            }
        }.navigationBarBackButtonHidden().ignoresSafeArea(.keyboard).toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button("Done") {hideKeyboard()}.foregroundStyle(.blue)
                }
            }
        }
        .onChange(of: exclusive) { if exclusive && !subscPriceSet {showAlert = true} }
        .alert("", isPresented: $showAlert) {
            Button("OK") {exclusive=false}
        } message: {
            Text("Please set your subscription price first")
        }
    }
}

#Preview {
    AddPostView()
}
