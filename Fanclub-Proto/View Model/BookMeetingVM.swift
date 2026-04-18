//
//  BookMeetingVM.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 3/21/26.
//
import SwiftUI
import PhotosUI
import UniformTypeIdentifiers
import AVFoundation

@MainActor
class BookMeetingVM: ObservableObject {
    private let profileManager = ProfileManager.shared
    
    @Published var step = 1 //select date/time is 1, booking fields is 2
    @Published var isLoading = false
    
    //MARK: Time & date
    @Published var slots: [MeetingSlot]? = []
    @Published var selectedSlot: MeetingSlot?
    
    //MARK: Booking Fields
    //Pronouns
    @Published var pronouns = ""
    let pronounChoices = ["He/Him", "She/Her", "They/Them"]//, "Other"]
    @Published var pronounsError = false
    @Published var showPronounsDropdown = false
    @Published var justOpenedDropdown = false
    
    //Media
    @Published var media: [PhotosPickerItem] = []
    @Published var resolvedMedia: [PickedMedia] = [] // Resolved, displayable media
    private var mediaMap: [(item: PhotosPickerItem, resolved: PickedMedia)] = [] // Mapping between picker items and resolved media
    
    func scheduleBooking() async throws {
        pronounsError = false
        isLoading = true
        if pronouns == "" { pronounsError = true ; isLoading = false ; return }
        do {
            isLoading = false
        } catch {
            print(error.localizedDescription)
            isLoading = false
            throw error
        }
    }

    func resolveMedia() async {
        mediaMap = []
        var results: [PickedMedia] = []
        for item in media {
            // Try image via Transferable
            if let picked = try? await item.loadTransferable(type: PickedImage.self) {
                let resolved = PickedMedia.image(picked.image)
                print("added image")
                results.append(resolved)
                mediaMap.append((item: item, resolved: resolved))
                continue
            }
            // Try video via Transferable (movie file URL)
            if let picked = try? await item.loadTransferable(type: PickedVideo.self) {
                let thumb = await generateThumbnail(for: picked.url)
                let resolved = PickedMedia.video(url: picked.url, thumbnail: thumb)
                print("added video")
                results.append(resolved)
                mediaMap.append((item: item, resolved: resolved))
                continue
            }
            // Unsupported/failed items are skipped
            print("couldnt add media")
        }
        resolvedMedia = results
    }
    
    func remove(picked: PickedMedia) {
        // Find mapping entry
        if let mapIndex = mediaMap.firstIndex(where: { $0.resolved == picked }) {
            let itemToRemove = mediaMap[mapIndex].item
            // Remove from picker selection
            self.media.removeAll { $0 == itemToRemove }
            // Remove from resolved list
            resolvedMedia.removeAll { $0 == picked }
            // Remove from map
            mediaMap.remove(at: mapIndex)
        }
    }
    
    func makeFakeSlots() {
        for i in 1...10 {
            let startTime = Date.now.addingTimeInterval(Double(i * 86400))
//            let endTime = startTime.addingTimeInterval(3600)    //1 hr slot
            let intOpts = ["2","5","10","15","20","30","60"]
            
            //set interval duration
            let intDur = intOpts.randomElement()!
            
            //get number of attendees so far
            let attInt = Int.random(in: 0...( 60 / (Int(intDur) ?? 60)))
            
            //get slot attendees since we know how many intervals there are
            var attObj: [MeetingSlotAttendee] = []
            if attInt > 0 {
                for j in 0..<attInt {
                    let attSlot = MeetingSlotAttendee(id: j, slot_id: i, slot_user_id: profileManager.profile?.id ?? 0, attendee_id: Int.random(in: 1...100), interval_index: j, start_time: startTime.addingTimeInterval(Double(j*(Int(intDur) ?? 1))).ISO8601Format(), duration: intDur, paid: false)
                    attObj.append(attSlot)
                }
            }
            
            //if all slots are taken, is_full should be true
            var full = false
            if attInt * (Int(intDur) ?? 1) == 60 { //assuming a 60 min meeting
                full = true
            }
            
            let newSlot = MeetingSlot(id: i, user_id: profileManager.profile?.id ?? 0, start_time: startTime.ISO8601Format(), duration: "60", zoom_meeting_id: "", zoom_meeting_password: "", zoom_start_url: "", amount: Double.random(in: 0...12), is_booked: false, is_meeting_started: false, is_meeting_ended: false, is_IRL_meeting: false, interval_duration: intOpts.randomElement()!, attendees: attInt, is_full: full, slot_attendees: attObj)
            
            slots?.append(newSlot)
        }
    }
}

enum PickedMedia: Identifiable, Hashable {
    case image(UIImage)
    case video(url: URL, thumbnail: UIImage?)

    var id: String {
        switch self {
        case .image(let img):
            return String(img.hashValue)
        case .video(let url, _):
            return url.absoluteString
        }
    }
}

struct PickedImage: Transferable {
    let image: UIImage

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            guard let image = UIImage(data: data) else {
                throw NSError(domain: "ImageDecode", code: -1)
            }
            return PickedImage(image: image)
        }
    }
}

struct PickedVideo: Transferable {
    let url: URL

    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(importedContentType: .movie) { received in
            // Provide a local file URL for the picked movie
            return PickedVideo(url: received.file)
        }
    }
}

func generateThumbnail(for url: URL) async -> UIImage? {
    await withCheckedContinuation { continuation in
        let asset = AVURLAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        // Ask for the first frame (you can adjust the time if you prefer)
        let time = CMTime(seconds: 0.0, preferredTimescale: 600)

        generator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { _, cgImage, _, _, _ in
            if let cgImage {
                continuation.resume(returning: UIImage(cgImage: cgImage))
            } else {
                continuation.resume(returning: nil)
            }
        }
    }
}

