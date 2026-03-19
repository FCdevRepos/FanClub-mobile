//
//  ProfileVM.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 3/17/26.
//
import SwiftUI

@MainActor
class ProfileVM: ObservableObject {
    private let profileManager = ProfileManager.shared
    
    @Published var isLoading = false
    @Published var updateError = false
    
    //Non-influencer type
    @Published var newImage: UIImage? = nil
    @Published var newName = ""
    @Published var newUsername = ""
    @Published var newDOB = Date.now
    @Published var newDOBAdded = false
    @Published var newCountry = ""
    @Published var newEmail = ""
    
    //Influencer type
        
    func setEditingFields() {
        //newImage =
        newName = profileManager.profile?.fullname ?? ""
        if newName.trimmingCharacters(in: [" "]) == "" {
            newName = ""
        }
        newUsername = profileManager.profile?.username ?? ""
        newCountry = profileManager.profile?.country ?? ""
        newEmail = profileManager.profile?.email ?? ""
        
        if profileManager.profile?.dob != nil {
            if profileManager.profile?.dob! != "" {
                newDOB = convertDateStringYYYYMMDDToSwiftDate(input: profileManager.profile?.dob ?? "") ?? Date.now
                
                if newDOB != Date.now { newDOBAdded = true }
                else { newDOBAdded = false }
            }
        }
        
    }
    
    func updateProfile() async throws {
        isLoading = true
        let rqData = (profileManager.profile?.influencer ?? false) ? getRequestDataInfluencer() : getRequestDataRegular()
        
        do {
            try await profileManager.updateProfile(requestData: rqData) { comp in
                if comp != 200 { self.updateError = true }
                self.isLoading = false
            }
        } catch {
            print(error.localizedDescription)
            isLoading = false
            throw error
        }
    }
    
    func getRequestDataRegular() -> [String : Any] {
        var dict: [String : Any] = [:]
        dict["user_id"] = profileManager.profile?.id ?? 0
        if newName != (profileManager.profile?.fullname ?? "") && newName.trimmingCharacters(in: [" "]) != "" { dict["fullname"] = newName }
        if newName.trimmingCharacters(in: [" "]) != "" {
            if newName.trimmingCharacters(in: [" "]).contains(" ") {
                dict["first_name"] = newName.split(separator: " ")[0]
                dict["last_name"] = newName.split(separator: " ")[1]
            } else {
                dict["first_name"] = newName
                dict["last_name"] = ""
            }
        }
        if newUsername != (profileManager.profile?.username ?? "") { dict["username"] = newUsername }
        if newEmail != (profileManager.profile?.email ?? "") { dict["email"] = newEmail }
        if newCountry != (profileManager.profile?.country ?? "") { dict["country"] = newCountry }
        
        //do date of birth (check newDOBAdded & newDOB != getDate(profile.dob)
        if newDOBAdded {
            let date = convertSwiftDateToDateStringYYYYMMDD(input: newDOB)
            if date != "" {
                dict["dob"] = date
            }
        }
        //TODO: check over 18??
        
        return dict
    }
    
    func getRequestDataInfluencer() -> [String : Any] {
        
        return [:]
    }
}
