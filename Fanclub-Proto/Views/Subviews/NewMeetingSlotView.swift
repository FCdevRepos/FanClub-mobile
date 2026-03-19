//
//  NewMeetingSlotView.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 9/11/24.
//

import SwiftUI

struct NewMeetingSlotView: View {
    @Environment(\.presentationMode) var pm
    
    @State var monthSel = Calendar.current.dateComponents([.month], from: Date.now).month ?? 1
    @State var yearSel = Calendar.current.dateComponents([.year], from: Date.now).year ?? 0
    
    @State var timeHour = 12
    @State var timeMin = 00
    @State var ampm = "AM"
    
    @State var meetingDate: Date = Date.now
    
    @State var duration = 2.0
    @State var coins = 0.0
    @State var priceOfCoins = 0.0
    
    @State var irl = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.opacity(0.88).ignoresSafeArea()
                VStack {
                    HStack {
                        Button {pm.wrappedValue.dismiss()} label: {
                            Image(systemName: "chevron.left").imageScale(.large).foregroundStyle(.white)
                        }
                        Text("Create Slot").foregroundStyle(GlobalVars.textColor).font(.title2).padding(.horizontal)
                        Spacer()
                    }.padding()
                    ScrollView {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15).foregroundStyle(.gray.opacity(0.5))
                            VStack {
                                DatePicker("", selection: $meetingDate, in: Date()..., displayedComponents: [.date])
                                    .datePickerStyle(.graphical)
                                    .colorScheme(.dark)
                                    //.padding(.top, 10).padding(.horizontal)
                                Rectangle().frame(height: 0.5).foregroundStyle(.white).padding(.horizontal)
                                HStack {
                                    Text("Time").foregroundStyle(.white).font(.title2)
                                    Spacer()
                                    //time picker
                                    HStack(spacing: -18) {
                                        Picker("", selection: $timeHour) {
                                            ForEach([12,01,02,03,04,05,06,07,08,09,10,11], id: \.self) { hour in
                                                Text("\(hour) :").foregroundStyle(.yellow).tag(hour)
                                            }
                                        }.pickerStyle(.wheel).frame(maxWidth: 60, maxHeight: 65)
                                        Picker("", selection: $timeMin) {
                                            ForEach(0...59, id: \.self) { min in
                                                Text("\(min, specifier: "%02d")").foregroundStyle(.yellow).tag(min)
                                            }
                                        }.pickerStyle(.wheel).frame(maxWidth: 60, maxHeight: 65)
                                        Picker("", selection: $ampm) {
                                            ForEach(["AM","PM"], id: \.self) { ap in
                                                Text("\(ap)").foregroundStyle(.yellow).tag(ap)
                                            }
                                        }.pickerStyle(.wheel).frame(maxWidth: 60, maxHeight: 65)
                                    }
                                }.padding(.horizontal)//.padding(.bottom, 10)
                            }.padding()
                        }.padding()
                        ZStack {
                            RoundedRectangle(cornerRadius: 15).foregroundStyle(.gray.opacity(0.5))
                            VStack {
                                HStack {
                                    Text("Meeting Duration").font(.callout).foregroundStyle(GlobalVars.textColor)
                                    Spacer()
                                }
                                StepSlider(value: $duration, in: [2,5,10,15,20,25,30,35,40]).tint(.yellow)
                                HStack {
                                    Text("2 mins").foregroundStyle(GlobalVars.textColor).font(.caption)
                                    Spacer()
                                    if duration != 2 && duration != 40 {
                                        Text("\(duration, specifier: "%.0f") mins").foregroundStyle(GlobalVars.textColor).font(.caption)
                                    }
                                    Spacer()
                                    Text("40 mins").foregroundStyle(GlobalVars.textColor).font(.caption)
                                }
                            }.padding()
                        }.padding()
                        ZStack {
                            RoundedRectangle(cornerRadius: 15).foregroundStyle(.gray.opacity(0.5))
                            VStack {
                                HStack {
                                    Text("Enter meeting price").font(.callout).foregroundStyle(GlobalVars.textColor)
                                    Spacer()
                                }
                                HStack {
                                    Text("Coins").font(.callout).foregroundStyle(GlobalVars.textColor)
                                    TextField("", value: $coins, format: .number).foregroundStyle(.white).keyboardType(.decimalPad)
                                    Spacer()
                                    Text("$\(priceOfCoins, specifier: "%.2f")").foregroundStyle(.white).font(.callout)
                                }
                            }.padding()
                        }.padding()
                        HStack {
                            Text("IRL Meeting?").foregroundStyle(.yellow).font(.title2)
                            Spacer()
                            Toggle(isOn: $irl) {}.tint(.green)
                        }.padding()
                        HStack {
                            Spacer()
                            Button {} label: {//or navigationstack?
                                Text("Save").font(.title3).foregroundStyle(.yellow)
                            }.padding(.bottom)
                        }.padding()
                    }
                }
            }
        }.navigationBarBackButtonHidden().tint(.white).toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button("Done") {hideKeyboard()}.foregroundStyle(.blue)
                }
            }
        }
        .onChange(of: coins) { priceOfCoins = coins * 0.25 }
    }
}

#Preview {
    NewMeetingSlotView()
}

struct StepSlider<T: Comparable>: View {
    @Binding var value: T
    let values: [T]
    private let upperBound: Float
    @State private var index: Int

    init(value: Binding<T>, in values: [T]) {
        self._value = value
        self._index = State(initialValue: values.firstIndex(of: value.wrappedValue) ?? 0)

        self.values = values
        self.upperBound = Float(values.count - 1)
    }

    var body: some View {
        Slider(value: Binding(
            get: { Float(index) },
            set: { index = Int($0); value = values[Int($0)] }
        ), in: 0...upperBound, step: 1)
    }
}
