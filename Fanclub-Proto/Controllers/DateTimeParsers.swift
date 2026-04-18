//
//  DateTimeParsers.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 3/25/26.
//
import SwiftUI

// Converts a YYYY-MM-DD string to a civil Date by constructing components at local noon (avoids timezone shifts).
func convertDateStringYYYYMMDDToSwiftDate(input: String) -> Date? {
    // Treat YYYY-MM-DD as a pure calendar date (no timezone semantics)
    let parts = input.split(separator: "-")
    guard parts.count == 3,
          let year = Int(parts[0]),
          let month = Int(parts[1]),
          let day = Int(parts[2]) else {
        return nil
    }
    var comps = DateComponents()
    comps.calendar = Calendar(identifier: .gregorian)
    comps.timeZone = .current
    comps.year = year
    comps.month = month
    comps.day = day
    comps.hour = 12 // noon to avoid DST-related shifts
    return comps.calendar?.date(from: comps)
}

// Converts an ISO 8601 date string to Date using ISO8601DateFormatter.
func convertDateStringISOToSwiftDate(input: String) -> Date? {
    //    let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
    //    let dateOnlyRegex = try? NSRegularExpression(pattern: "^\\d{4}-\\d{2}-\\d{2}(?:Z)?$", options: [])
    //    if let regex = dateOnlyRegex,
    //       regex.firstMatch(in: trimmed, options: [], range: NSRange(location: 0, length: trimmed.utf16.count)) != nil {
    //        let parts = trimmed.replacingOccurrences(of: "Z", with: "").split(separator: "-")
    //        if parts.count == 3, let year = Int(parts[0]), let month = Int(parts[1]), let day = Int(parts[2]) {
    //            var comps = DateComponents()
    //            comps.calendar = Calendar(identifier: .gregorian)
    //            comps.timeZone = .current
    //            comps.year = year
    //            comps.month = month
    //            comps.day = day
    //            comps.hour = 12 // noon to avoid DST-related shifts
    //            return comps.calendar?.date(from: comps)
    //        }
    //    }
    //    // Otherwise parse full ISO 8601 timestamp (moment-in-time)
    //    let isoFormatter = ISO8601DateFormatter()
    //    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    //    if let date = isoFormatter.date(from: trimmed) {
    //        return date
    //    }
    //    isoFormatter.formatOptions = [.withInternetDateTime]
    //    return isoFormatter.date(from: trimmed)
    
    let isoFormatter = ISO8601DateFormatter()
    // Support fractional seconds if present
    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    if let date = isoFormatter.date(from: input) {
        return date
    }
    // Fallback without fractional seconds
    isoFormatter.formatOptions = [.withInternetDateTime]
    return isoFormatter.date(from: input)
}

// Converts a Date to a string in the format "YYYY-MM-DD" using UTC to be stable across locales/time zones.
func convertSwiftDateToDateStringYYYYMMDD(input: Date) -> String {
    //
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.locale = Locale(identifier: "en_US_POSIX")
//    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.timeZone = .current
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: input)
    
    //make it so it can return time too?
}

// Converts a Date to an ISO 8601 string with fractional seconds and Zulu time.
func convertSwiftDateToDateStringISO(input: Date) -> String {
    let isoFormatter = ISO8601DateFormatter()
//    isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    isoFormatter.timeZone = .current
    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return isoFormatter.string(from: input)
    
    //make it so it can return time too?
}

func convertYYYYMMDDDateStringToLocaleDateString(input: String) -> String? {
    let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
    let parts = trimmed.split(separator: "-")
    guard parts.count == 3,
          let year = Int(parts[0]),
          let month = Int(parts[1]),
          let day = Int(parts[2]) else {
        print("could not convert \(input) to locale string")
        return nil
    }
    var comps = DateComponents()
    comps.calendar = Calendar(identifier: .gregorian)
    comps.timeZone = .current
    comps.year = year
    comps.month = month
    comps.day = day
    comps.hour = 12
    guard let date = comps.calendar?.date(from: comps) else {
        print("could not convert \(input) to locale string")
        return nil
    }
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.locale = Locale.current
    formatter.timeZone = .current
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter.string(from: date)
    
    //make it so it can return time too?
}

// Date-only ISO strings are treated as civil dates.
func convertISODateStringToLocaleDateString(input: String) -> String? {
//    let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
//    // Treat date-only ISO as civil date to avoid timezone shifts
//    if let match = trimmed.range(of: "^\\d{4}-\\d{2}-\\d{2}(?:Z)?$", options: .regularExpression) {
//        let dateOnly = String(trimmed[match]).replacingOccurrences(of: "Z", with: "")
//        let parts = dateOnly.split(separator: "-")
//        if parts.count == 3, let year = Int(parts[0]), let month = Int(parts[1]), let day = Int(parts[2]) {
//            var comps = DateComponents()
//            comps.calendar = Calendar(identifier: .gregorian)
//            comps.timeZone = .current
//            comps.year = year
//            comps.month = month
//            comps.day = day
//            comps.hour = 12
//            if let date = comps.calendar?.date(from: comps) {
//                let formatter = DateFormatter()
//                formatter.calendar = Calendar(identifier: .gregorian)
//                formatter.locale = Locale.current
//                formatter.timeZone = .current
//                formatter.dateStyle = .medium
//                formatter.timeStyle = .none
//                return formatter.string(from: date)
//            }
//        }
//        print("could not convert \(input) to locale string")
//        return nil
//    }
//    // Otherwise parse full ISO timestamp
//    guard let date = convertDateStringISOToSwiftDate(input: trimmed) else {
//        print("could not convert \(input) to locale string")
//        return nil
//    }
//    let formatter = DateFormatter()
//    formatter.calendar = Calendar(identifier: .gregorian)
//    formatter.locale = Locale.current
//    formatter.timeZone = .current
//    formatter.dateStyle = .medium
//    formatter.timeStyle = .none
//    return formatter.string(from: date)
    
    guard let date = convertDateStringISOToSwiftDate(input: input) else {
        print("could not convert \(input) to locale string")
        return nil
    }
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.locale = Locale.current
    formatter.timeZone = .current
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter.string(from: date)
    
    //make it so it can return time too?
}

func getTimeFromYYYYMMDDDateString(input: String) -> String? {
    guard let date = convertDateStringYYYYMMDDToSwiftDate(input: input) else {
        return nil
    }
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.locale = .current
    formatter.timeZone = .current
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter.string(from: date)
}

func getTimeFromISODateString(input: String) -> String? {
    guard let date = convertDateStringISOToSwiftDate(input: input) else {
        return nil
    }
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.locale = Locale.current
    formatter.timeZone = .current
    formatter.dateStyle = .none
    formatter.timeStyle = .short // e.g., "3:45 PM" based on locale
    return formatter.string(from: date)
}

func getTimeFromYYYYMMDDDate(input: Date) -> String? {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.locale = Locale.current
    formatter.timeZone = .current
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter.string(from: input)
}

func getTimeFromISODate(input: Date) -> String? {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.locale = Locale.current
    formatter.timeZone = .current
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter.string(from: input)
}


