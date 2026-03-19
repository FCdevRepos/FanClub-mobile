//
//  Creator.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 3/5/26.
//
import SwiftUI

struct Creator: Hashable, Codable {
    let id: String?
    let name: String?
    let tags: [String]?
    let fans: Int?
    let avatar: String?
    let coverImage: String?
    
    init(id: String? = "", name: String? = "", tags: [String]? = [], fans: Int? = 0, avatar: String? = "", coverImage: String? = "") {
        self.id = id
        self.name = name
        self.tags = tags
        self.fans = fans
        self.avatar = avatar
        self.coverImage = coverImage
    }
}
