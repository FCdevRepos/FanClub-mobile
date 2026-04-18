//
//  Meeting.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 3/25/26.
//
import SwiftUI

struct MeetingSlot: Hashable, Codable {
    let id: Int?
    let user_id: Int?
    let start_time: String? //date?
    let duration: String? //int?
    let zoom_meeting_id: String?    //TO REMOMVE
    let zoom_meeting_password: String?    //TO REMOMVE
    let zoom_start_url: String?    //TO REMOMVE
    let amount: Double?
    let is_booked: Bool?            //TO REMOVE
    let is_meeting_started: Bool?
    let is_meeting_ended: Bool?
    let is_IRL_meeting: Bool?
    let interval_duration: String?  //int?
    let attendees: Int?
    let is_full: Bool?
    
    let slot_attendees: [MeetingSlotAttendee]?
    
    init(id: Int? = 0, user_id: Int? = 0, start_time: String? = "", duration: String? = "", zoom_meeting_id: String? = "", zoom_meeting_password: String? = "", zoom_start_url: String? = "", amount: Double? = 0, is_booked: Bool? = false, is_meeting_started: Bool? = false, is_meeting_ended: Bool? = false, is_IRL_meeting: Bool? = false, interval_duration: String? = "", attendees: Int? = 0, is_full: Bool? = false, slot_attendees: [MeetingSlotAttendee]? = []) {
        self.id = id
        self.user_id = user_id
        self.start_time = start_time
        self.duration = duration
        self.zoom_meeting_id = zoom_meeting_id
        self.zoom_meeting_password = zoom_meeting_password
        self.zoom_start_url = zoom_start_url
        self.amount = amount
        self.is_booked = is_booked
        self.is_meeting_started = is_meeting_started
        self.is_meeting_ended = is_meeting_ended
        self.is_IRL_meeting = is_IRL_meeting
        self.interval_duration = interval_duration
        self.attendees = attendees
        self.is_full = is_full
        self.slot_attendees = slot_attendees
    }
}

struct MeetingSlotAttendee: Hashable, Codable {
    let id: Int?
    let slot_id: Int?
    let slot_user_id: Int?
    let attendee_id: Int?
    let interval_index: Int?
    let start_time: String? //date?
    let duration: String?   //int?
    let paid: Bool?
    
    init(id: Int? = 0, slot_id: Int? = 0, slot_user_id: Int? = 0, attendee_id: Int? = 0, interval_index: Int? = 0, start_time: String? = "", duration: String? = "", paid: Bool? = false) {
        self.id = id
        self.slot_id = slot_id
        self.slot_user_id = slot_user_id
        self.attendee_id = attendee_id
        self.interval_index = interval_index
        self.start_time = start_time
        self.duration = duration
        self.paid = paid
    }
}

struct Meeting: Hashable, Codable {
    let id: Int?
    let meeting_slot_id: Int?
    let influencer_id: Int?
    let guest_id: Int?    //TO REMOVE?
//    let attendees: ??
    let occasion: String?
    let meeting_media: String?
    let meeting_type: String?
    let boost_amount: Double?
    let meeting_pronouns: String?
    let meeting_agenda: String?
    let instruction: String?
    let who_is_this_for: String?
    let has_payment_done: Bool?
    let is_cancelled: Bool?
//    let zoom_join_url: String?    //TO REMOVE?
    let start_time: String? //date?
    let duration: String?   //int?
    let end_time: String? //date?
    let influencer_name: String?
    let booked_on: Int? //what is this?
    let zoom_meeting_id: String?    //TO REMOVE
    let zoom_meeting_password: String?      //TO REMOVE
    let amount: Double?
    
    init(id: Int? = 0, meeting_slot_id: Int? = 0, influencer_id: Int? = 0, guest_id: Int? = 0, occasion: String? = "", meeting_media: String? = "", meeting_type: String? = "", boost_amount: Double? = 0, meeting_pronouns: String? = "", meeting_agenda: String? = "", instruction: String? = "", who_is_this_for: String? = "", has_payment_done: Bool? = false, is_cancelled: Bool? = false, start_time: String? = "", duration: String? = "", end_time: String? = "", influencer_name: String? = "", booked_on: Int? = 0, zoom_meeting_id: String? = "", zoom_meeting_password: String? = "", amount: Double? = 0) {
        self.id = id
        self.meeting_slot_id = meeting_slot_id
        self.influencer_id = influencer_id
        self.guest_id = guest_id
        self.occasion = occasion
        self.meeting_media = meeting_media
        self.meeting_type = meeting_type
        self.boost_amount = boost_amount
        self.meeting_pronouns = meeting_pronouns
        self.meeting_agenda = meeting_agenda
        self.instruction = instruction
        self.who_is_this_for = who_is_this_for
        self.has_payment_done = has_payment_done
        self.is_cancelled = is_cancelled
        self.start_time = start_time
        self.duration = duration
        self.end_time = end_time
        self.influencer_name = influencer_name
        self.booked_on = booked_on
        self.zoom_meeting_id = zoom_meeting_id
        self.zoom_meeting_password = zoom_meeting_password
        self.amount = amount
    }
}
