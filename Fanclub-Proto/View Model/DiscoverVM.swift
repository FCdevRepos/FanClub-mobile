//
//  DiscoverVM.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 3/5/26.
//
import SwiftUI

class DiscoverVM: ObservableObject {

    @Published var creators: [Creator] = []
    @Published var displayedCreators: [Creator] = []
    
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let tags = ["Youtuber","Streamer","Athlete","Musician","Photographer","Videographer","Gamer","Content Creator","Educator","Makeup Artist","Super Long Tag that def wont fit on one line"]
    let names = ["Austin Moca","Alex Saddler","Marcos Saita","Jamison Saddler","Michael Jordan","Kanye West","Shaquille O'Neal","Caleb Williams","LeBron James","Scottie Scheffler","Really Long Long Name 1 Version 1","Really Long Long Name 2 Version 2"]
    
    @Published var activeTags: [String] = []
    
    @Published var tagFilter = "All"
    @Published var searchTerm = ""
    
    func createTestData() {
        creators.removeAll()
        for _ in 0..<10 {
            let randTagsAmt = Int.random(in: 1...5)
            let newC = Creator(id: String((0..<10).map { _ in letters.randomElement()! }), name: names.randomElement()!, tags: makeTags(randTagsAmt), fans: Int.random(in: 0...100), avatar: "", coverImage: "")
            creators.append(newC)
            displayedCreators.append(newC)
        }
        
        func makeTags(_ randTagsAmt: Int) -> [String] {
            var localTags: [String] = []
            
            for _ in 0..<randTagsAmt {
                var rand = tags.randomElement()!
                
                while rand == "" || localTags.contains(rand) { rand = tags.randomElement()!}
                
                localTags.append(rand)
//                print("added \(rand) to tags")
            }
            
            for t in localTags {
                if !activeTags.contains(t) {
                    activeTags.append(t)
                }
            }
            
            return localTags
        }
    }
    
    func updateTagFilter() {
        filterCreators()
    }
    
    func updateSearch() {
        filterCreators()
    }
    
    func filterCreators() {
        let term = searchTerm.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let hasSearch = !term.isEmpty
        let tag = tagFilter.trimmingCharacters(in: .whitespacesAndNewlines)
        let hasTag = !tag.isEmpty && tag.lowercased() != "all"

        displayedCreators = creators.filter { creator in
            // Tag filter (only if active)
            let passesTag: Bool = {
                guard hasTag else { return true }
                let tags = (creator.tags ?? []).map { $0.lowercased() }
                return tags.contains(tag.lowercased())
            }()

            // Search filter (only if active)
            let passesSearch: Bool = {
                guard hasSearch else { return true }
                let name = (creator.name ?? "").lowercased()
                let id = (creator.id ?? "").lowercased()
                let tags = (creator.tags ?? []).map { $0.lowercased() }
                return name.contains(term) || id == term || tags.contains(where: { $0.contains(term) })
            }()

            return passesTag && passesSearch
        }
    }
    
    //make func for both tag and filter?
}

