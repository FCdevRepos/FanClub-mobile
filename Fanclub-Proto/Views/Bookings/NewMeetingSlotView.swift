//
//  NewMeetingSlotView.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 9/11/24.
//

import SwiftUI

struct NewMeetingSlotView: View {
    @Environment(\.presentationMode) var pm
    @StateObject var vm = NewSlotVM()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color
                    .black.opacity(0.88)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Button { pm.wrappedValue.dismiss() } label: {
                            Image(systemName: "chevron.left")
                                .imageScale(.large)
                                .foregroundStyle(.white)
                        }
                        Text("Create Slot")
                            .foregroundStyle(GlobalVars.textColor)
                            .font(.title2)
                            .padding(.horizontal)
                        Spacer()
                    }.padding()
                    ScrollView {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(.gray.opacity(0.5))
                            VStack {
                                DatePicker("", selection: $vm.meetingDate, in: Date()..., displayedComponents: [.date])
                                    .datePickerStyle(.graphical)
                                    .colorScheme(.dark)
                                    //.padding(.top, 10).padding(.horizontal)
                                Rectangle()
                                    .frame(height: 0.5)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal)
                                HStack {
                                    Text("Time")
                                        .foregroundStyle(.white)
                                        .font(.title2)
                                    Spacer()
                                    //time picker
                                    HStack(spacing: -18) {
                                        Picker("", selection: $vm.timeHour) {
                                            ForEach([12,01,02,03,04,05,06,07,08,09,10,11], id: \.self) { hour in
                                                Text("\(hour) :")
//                                                    .foregroundStyle(.yellow)
                                                    .foregroundStyle(.white)
                                                    .tag(hour)
                                            }
                                        }.pickerStyle(.wheel).frame(maxWidth: 60, maxHeight: 65)
                                        Picker("", selection: $vm.timeMin) {
                                            ForEach(Array(stride(from: 0, through: 55, by: 5)), id: \.self) { min in
                                                Text("\(min, specifier: "%02d")")
//                                                    .foregroundStyle(.yellow)
                                                    .foregroundStyle(.white)
                                                    .tag(min)
                                            }
                                        }.pickerStyle(.wheel).frame(maxWidth: 60, maxHeight: 65)
                                        Picker("", selection: $vm.ampm) {
                                            ForEach(["AM","PM"], id: \.self) { ap in
                                                Text("\(ap)")
//                                                    .foregroundStyle(.yellow)
                                                    .foregroundStyle(.white)
                                                    .tag(ap)
                                            }
                                        }.pickerStyle(.wheel).frame(maxWidth: 60, maxHeight: 65)
                                    }
                                }.padding(.horizontal)//.padding(.bottom, 10)
                            }.padding()
                        }.padding()
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(.gray.opacity(0.5))
                            VStack {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Meeting Duration")
                                            .font(.callout)
                                            .foregroundStyle(GlobalVars.textColor)
                                        Text("The total duration you will be available")
                                            .font(.footnote)
                                            .foregroundStyle(.gray)
                                    }
                                    Spacer()
                                }
                                StepSlider(value: $vm.slotDuration, in: [5,10,15,20,25,30,35,40,45,50,55,60]).tint(.yellow)
                                HStack {
                                    Text("5 mins")
                                        .foregroundStyle(GlobalVars.textColor)
                                        .font(.caption)
                                    Spacer()
                                    if vm.slotDuration != 5 && vm.slotDuration != 60 {
                                        Text("\(vm.slotDuration, specifier: "%.0f") mins")
                                            .foregroundStyle(GlobalVars.textColor)
                                            .font(.caption)
                                    }
                                    Spacer()
                                    Text("1 hr")
                                        .foregroundStyle(GlobalVars.textColor)
                                        .font(.caption)
                                }.padding(.bottom)
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Meeting Intervals")
                                            .font(.callout)
                                            .foregroundStyle(GlobalVars.textColor)
                                        Text("How long each attendee will be on the call")
                                            .font(.footnote)
                                            .foregroundStyle(.gray)
                                    }
                                    Spacer()
                                }
                                StepSlider(value: $vm.intervalDuration, in: [2,5,10,15,20,25,30]).tint(.yellow)
//                                StepSlider(value: $vm.intervalDuration, in: vm.getIntervalSteps()).tint(.yellow)
                                HStack {
                                    Text("2 mins")
                                        .foregroundStyle(GlobalVars.textColor)
                                        .font(.caption)
                                    Spacer()
                                    if vm.intervalDuration != 2 && vm.intervalDuration != 30 {
                                        Text("\(vm.intervalDuration, specifier: "%.0f") mins")
                                            .foregroundStyle(GlobalVars.textColor)
                                            .font(.caption)
                                    }
                                    Spacer()
                                    Text("30 mins")
                                        .foregroundStyle(GlobalVars.textColor)
                                        .font(.caption)
                                }//.padding(.bottom)
                                Text("This slot will hold a maximum of \(Int(vm.slotDuration) / Int(vm.intervalDuration)) attendees")
                                    .foregroundStyle(.gray).opacity(0.65)
                                    .italic()
                                    .font(.footnote)
                                    .padding(.vertical)
                                //round up? if 15 slot, 2 interval -> "maximum of 8 attendees"
                                if vm.intervalDuration > vm.slotDuration {
                                    Text("Interval duration cannot be greater than total meeting duration")
                                        .font(.footnote)
                                        .foregroundStyle(.red)
                                        .padding()
                                        .multilineTextAlignment(.center)
                                        .italic()
                                }
                            }.padding()
                        }.padding()
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(.gray.opacity(0.5))
                            VStack {
                                HStack {
                                    Text("Enter meeting price")
                                        .font(.callout)
                                        .foregroundStyle(GlobalVars.textColor)
                                    Spacer()
                                }
                                HStack {
                                    Text("Coins")
                                        .font(.callout)
                                        .foregroundStyle(GlobalVars.textColor)
                                    TextField("", value: $vm.coins, format: .number)
                                        .foregroundStyle(.white)
                                        .keyboardType(.decimalPad)
                                    Spacer()
                                    Text("$\(vm.priceOfCoins, specifier: "%.2f")")
                                        .foregroundStyle(.white)
                                        .font(.callout)
                                }
                            }.padding()
                        }.padding()
                        HStack {
                            Text("IRL Meeting?")
                                .foregroundStyle(.yellow)
                                .font(.title2)
                            Spacer()
                            Toggle(isOn: $vm.irl) {}
                                .tint(.yellow)
                        }.padding()
                        HStack {
                            Spacer()
                            Button {} label: {//or navigationstack?
                                Text("Save")
                                    .font(.title3)
                                    .foregroundStyle(.yellow)
                            }.padding(.bottom).disabled(vm.intervalDuration > vm.slotDuration)
                        }.padding()
                    }
                }
            }
        }.navigationBarBackButtonHidden()
            .tint(.white)
            .onTapGesture { hideKeyboard() }
            .toolbar {
//            ToolbarItemGroup(placement: .keyboard) {
//                HStack {
//                    Spacer()
//                    Button("Done") {hideKeyboard()}
//                        .foregroundStyle(.blue)
//                }
//            }
        }
            .onChange(of: vm.coins) { vm.priceOfCoins = vm.coins * 0.25 }
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
