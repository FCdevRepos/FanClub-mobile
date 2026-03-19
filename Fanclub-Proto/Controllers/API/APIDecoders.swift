//
//  APIDecoders.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 3/13/26.
//
import SwiftUI

struct APIDecoders {
    
    func getFormatter() -> DateFormatter {
        // If you map created_at to Date, set a date strategy; otherwise skip this.
        // Example for fractional seconds ISO8601:

        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        
        return formatter
    }
    
    func decodeLoginResponse(jsonData: String) throws -> APIResponseSchemas.LoginResponseSchema {
        guard let data = jsonData.data(using: .utf8) else {
            throw NSError(domain: "APIDecoders", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid UTF-8 string"])
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(getFormatter())

        return try decoder.decode(APIResponseSchemas.LoginResponseSchema.self, from: data)
    }
    
    func decodeUserResponse(jsonData: String) throws -> APIResponseSchemas.UserResponseSchema {
        guard let data = jsonData.data(using: .utf8) else {
            throw NSError(domain: "APIDecoders", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid UTF-8 string"])
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(getFormatter())

        return try decoder.decode(APIResponseSchemas.UserResponseSchema.self, from: data)
    }
}
