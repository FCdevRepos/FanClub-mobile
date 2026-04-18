//
//  BookMeetingView.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 3/21/26.
//
import SwiftUI
import PhotosUI
import AVKit

struct BookMeetingView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm = BookMeetingVM()
    
    @FocusState var pronounsFocused: Bool
    
    let creator: Creator
    
    let bgColor = Color(red: 42/255, green: 42/255, blue: 42/255)
    
    var body: some View {
        ZStack {
            Color
                .black.opacity(0.92)
                .ignoresSafeArea()
            VStack {
                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .imageScale(.large)
                            .foregroundStyle(.white)
                    }.disabled(vm.isLoading)
                    Text("Schedule a meeting")
                        .foregroundStyle(GlobalVars.textColor)
                        .font(.custom("Nunito-Regular", size: 24))
                        .padding(.horizontal)
                    Spacer()
                }.padding()
                HStack {
                    if let url = URL(string: creator.avatar ?? ""), !url.absoluteString.isEmpty {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .frame(width: 65, height: 60)
                                .clipShape(Circle())
                        } placeholder: {
                            Image(.man)
                                .resizable()
                                .frame(width: 65, height: 60)
                                .clipShape(Circle())
                        }
                    } else {
                        Image(.man)
                            .resizable()
                            .frame(width: 65, height: 60)
                            .clipShape(Circle())
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        Text(creator.name ?? "")
                            .foregroundStyle(.white)
                            .font(.custom("Nunito-Bold", size: 17))
                        Text(getTagsString())
                            .foregroundStyle(.white.opacity(0.7))
                            .font(.custom("Nunito-Light", size: 15))
                            .lineLimit(3)
                            .minimumScaleFactor(0.5)
                    }
                    Spacer()
                    Text("\(creator.fans ?? 0) followers")
                        .foregroundStyle(.white.opacity(0.8))
                        .font(.custom("Nunito-Light", size: 15))
                }.padding(.top).padding(.horizontal).padding(.bottom, 5)
                if vm.step == 2 {
                    //show booked time & duration
                    HStack {
                        Button { withAnimation { vm.step = 1 } } label: {
                            Text("Change")
                                .foregroundStyle(.orange.opacity(0.7))
                                .font(.custom("Nunito-Light", size: 14))
                        }
                        Spacer()
                    }.padding(.horizontal)
                }
                Rectangle()
                    .frame(height: 0.75)
                    .foregroundStyle(.gray.opacity(0.75))
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                //TODO: add scrollview?
                switch vm.step {
                case 1:
                    VStack {
                        HStack {
                            Text("Select an available slot to book")
                                .foregroundStyle(.white.opacity(0.6))
                                .font(.custom("Nunito-Regular", size: 18))
                                .multilineTextAlignment(.leading)
                            Spacer()
                            if vm.selectedSlot != nil {
                                Button {
                                    withAnimation { vm.step = 2 }
                                } label: {
                                    Text("Next")
                                        .foregroundStyle(GlobalVars.YellowText)
                                        .font(.custom("Nunito-Medium", size: 21))
                                }
                            }
                        }.padding(.vertical, 8).padding(.horizontal)
                        ScrollView {
                            VStack {
                                //get slots for creator id, show available slots, show start time of next slot open for each
                                //(if meeting starts at 10 for 60 mins, but 4 intervals booked and interval dur. is 10 min, show 10:40 & 10:50 available)
                                //select one and go to next step
                                ForEach(vm.slots ?? [], id: \.self) { slot in
                                    if !(slot.is_full ?? false) {
                                        SlotBlock(slot: slot, vm: vm)
                                            .fixedSize(horizontal: false, vertical: true)
                                            .padding(.horizontal)
                                            .padding(.vertical, 5)
                                            .onTapGesture {
                                                if vm.selectedSlot == slot {
                                                    withAnimation { vm.selectedSlot = nil }
                                                } else {
                                                    withAnimation { vm.selectedSlot = slot }
                                                }
                                            }
                                    }
                                }
                            }
                        }
                    }
                case 2:
                    VStack {
                        //PRONOUNS
                        Group {
                            HStack {
                                Text("Add pronouns")
                                    .foregroundStyle(.white.opacity(0.6))
                                    .font(.custom("Nunito-Regular", size: 16))
                                Spacer()
                            }.padding(.horizontal)
                            VStack(spacing: 2) {
                                ZStack {
                                    if pronounsFocused || vm.showPronounsDropdown {
                                        UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 10, style: .continuous)
                                            .stroke(vm.pronounsError ? .red : .gray, lineWidth: 0.5)
                                    } else {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(vm.pronounsError ? .red : .gray, lineWidth: 0.5)
                                    }
                                    HStack {
                                        TextField("Type or select an option", text: $vm.pronouns)
                                            .foregroundStyle(.white)
                                            .font(.custom("Montserrat-Regular", size: 17))
                                            .focused($pronounsFocused)
                                        Spacer()
                                        Button {
                                            withAnimation { vm.showPronounsDropdown.toggle() }
                                        } label: {
                                            Image(systemName: pronounsFocused || vm.showPronounsDropdown ? "chevron.up" : "chevron.down")
                                                .imageScale(.large)
                                                .foregroundStyle(.gray)
                                        }
                                    }.padding(12)
                                }
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.bottom, pronounsFocused || vm.showPronounsDropdown ? 0 : 20)
                                if pronounsFocused || vm.showPronounsDropdown {
                                    ZStack {
                                        UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 10, bottomTrailingRadius: 10, topTrailingRadius: 0, style: .continuous)
                                            .foregroundStyle(bgColor)
                                        VStack(spacing: 5) {
                                            ForEach(vm.pronounChoices, id: \.self) { pn in
                                                if (pn.lowercased().contains(vm.pronouns.lowercased())) || (vm.pronouns.isEmpty) || vm.justOpenedDropdown {
                                                    VStack {
                                                        Button {
                                                            withAnimation {
                                                                vm.pronouns = pn
                                                                pronounsFocused = false
                                                                vm.showPronounsDropdown = false
                                                            }
                                                        } label: {
                                                            HStack {
                                                                Text(pn)
                                                                    .foregroundStyle(.white.opacity(0.75))
                                                                    .font(.custom("Montserrat-Regular", size: 17))
                                                                Spacer()
                                                            }
                                                        }.padding(.horizontal).padding(.top, 8)
                                                        Divider()
                                                    }
                                                }
                                            }
                                        }
                                    }.fixedSize(horizontal: false, vertical: true)
                                }
                            }.padding(.horizontal)
                        }
                        //MEDIA
                        Group {
                            HStack {
                                Text("Add photo/video")
                                    .foregroundStyle(.white.opacity(0.6))
                                    .font(.custom("Nunito-Regular", size: 16))
                                Spacer()
                                PhotosPicker(selection: $vm.media, maxSelectionCount: 9, matching: .any(of: [.images, .videos])) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundStyle(.white.opacity(0.9))
                                        .imageScale(.large)
                                        .padding(10)
                                }
                            }.padding(.top).padding(.horizontal)
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                                ForEach(vm.resolvedMedia) { item in
                                    switch item {
                                    case .image(let uiImage):
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
//                                            .frame(height: 90)
                                            .frame(width: 100, height: 100)
                                            .clipShape(RoundedRectangle(cornerRadius: 5))
                                            .clipped()
                                            .padding(5)
                                            .overlay(alignment: .bottomTrailing) {
                                                Button {
//                                                    vm.remove(media: item)
                                                } label: {
                                                    ZStack {
                                                        Circle()
                                                            .fill(.gray)
                                                        Image(systemName: "xmark")
                                                            .foregroundStyle(.white)
                                                            .imageScale(.medium)
                                                            .padding(4)
                                                    }
                                                }.fixedSize()
                                            }
                                    case .video(let url, let thumbnail):
                                        ZStack {
                                            if let thumbnail {
                                                Image(uiImage: thumbnail)
                                                    .resizable()
                                                    .scaledToFill()
                                            } else {
                                                // Fallback if thumbnail generation failed
                                                Color.black.opacity(0.2)
                                            }
                                            Image(systemName: "play.circle.fill")
                                                .foregroundStyle(.white)
                                                .imageScale(.large)
                                                .shadow(radius: 2)
                                        }
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .overlay(alignment: .bottomTrailing) {
                                            Button {
//                                                vm.remove(media: item)
                                            } label: {
                                                ZStack {
                                                    Circle()
                                                        .fill(.gray)
                                                    Image(systemName: "xmark")
                                                        .foregroundStyle(.white)
                                                        .imageScale(.medium)
                                                        .padding(4)
                                                }
                                            }.fixedSize()
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        Button {
                            Task { try await vm.scheduleBooking() }
                        } label: {
                            Text("Schedule Meeting")
                                .foregroundStyle(GlobalVars.YellowText)
                                .font(.custom("Nunito-Medium", size: 21))
                        }.disabled(vm.isLoading).padding()
                        Spacer()
                    }
                default: EmptyView()
                }
                Spacer()
            }.ignoresSafeArea(.keyboard)
        }.navigationBarBackButtonHidden().onTapGesture { hideKeyboard(); vm.showPronounsDropdown = false }
            .onChange(of: vm.media) {
                Task { await vm.resolveMedia() }
            }
            .onChange(of: pronounsFocused) {
                if pronounsFocused { vm.justOpenedDropdown = true }
                if !pronounsFocused && vm.showPronounsDropdown {
                    vm.showPronounsDropdown = false
                }
            }
            .onChange(of: vm.pronouns) {
                if vm.justOpenedDropdown { vm.justOpenedDropdown = false }
                if vm.pronounsError && !vm.pronouns.isEmpty {
                    vm.pronounsError = false
                }
            }
            .onChange(of: vm.showPronounsDropdown) {
                if vm.showPronounsDropdown { vm.justOpenedDropdown = true }
            }
            .onAppear {
                vm.makeFakeSlots()
            }
    }
    
    func getTagsString() -> String {
        if (creator.tags ?? []).count == 1 {
            return (creator.tags ?? []).first ?? ""
        } else {
            return (creator.tags ?? []).joined(separator: ", ")
        }
    }
}

struct SlotBlock: View {
    let slot: MeetingSlot
    @ObservedObject var vm: BookMeetingVM
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(uiColor: .darkGray))
                .stroke(Color.white, lineWidth: vm.selectedSlot == slot ? 6 : 0)
            HStack {
                VStack(alignment: .leading, spacing: 15) {
                    HStack(spacing: 12) {
                        Image(systemName: "calendar")
                            .imageScale(.medium)
                            .foregroundStyle(.white.opacity(0.8))
                        VStack(alignment: .leading, spacing: 3) {
                            Text(convertISODateStringToLocaleDateString(input: slot.start_time ?? "") ?? "")
                                .foregroundStyle(.white)
                                .font(.custom("Montserrat-Regular", size: 18))
                            //start time may not be at meeting start depeneding on num attendees
                            Text(getStartTime())
                                .foregroundStyle(.white)
                                .font(.custom("Montserrat-Regular", size: 18))
                        }
                    }
                    HStack(spacing: 12) {
                        Image(systemName: "clock")
                            .imageScale(.medium)
                            .foregroundStyle(.white.opacity(0.8))
                        Text("\(slot.interval_duration ?? "")m")
                            .foregroundStyle(.white)
                            .font(.custom("Montserrat-Regular", size: 17))
                    }
                }
                Spacer()
                Text("\(slot.amount ?? 0, specifier: "%.2f") coins")
                    .foregroundStyle(.white)
                    .font(.custom("Montserrat-Regular", size: 18))
            }.padding()
        }
    }
    
    func getStartTime() -> String {
        let defStart = getTimeFromISODate(input: convertDateStringISOToSwiftDate(input: slot.start_time ?? "") ?? Date.now) ?? ""
        //getTimeFromISODate(input: convertDateStringISOToSwiftDate(input: slot.start_time ?? "") ?? Date.now) ?? ""
        
        //if we have a start time of 12pm, duration of 60 mins, 10 min intervals, and 4 attendees already:
            //then next available time should be 12:40pm
        //BUT - what if one of the attendees cancels? we don't know which time slot they cancelled
            //actually we do -> get the MeetingSlotAttendee records for this meeting slot
            //if any MSA interval_index is skipped, we can put them there
            //example"
        /*
            meeting starts at 12pm, duration is 60m, slot interval is 10m
            first 4 spots are booked - 12, 12:10, 12:20, 12:30
            interval_index would be 0, 1, 2, 3
            slot 3 cancels -> 12:20 and index 2 are deleted
            now refetch MSA and we see 12 (0), 12:10 (1), 12:30 (3)
            so we display open time as 12:20 and book user for slot 3 (index 2)
         
         */
        
        if (slot.slot_attendees ?? []).count == 0 {
            return defStart
        } else {
            //find earliest slot available
            //if slot attendees index is skipped, put it there
            //else put it at end of attendees indexglobal
        }
        
        return defStart
    }
}

