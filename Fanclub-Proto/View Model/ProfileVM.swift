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
    @AppStorage("userId") var userId = 0
    
    //MARK: Edit Profile Variables
    @Published var isLoading = false
    @Published var updateError = false
    
//    @Published var emptyFieldError = false
    
    //Non-influencer type
    @Published var newName = ""
    @Published var newUsername = ""
    @Published var newEmail = ""
    @Published var newDOB = Date.now
    @Published var newDOBAdded = false
    @Published var newCountry = ""
    
    //phone
    @Published var newPhone = ""
    @Published var sentCode = false
    @Published var otpCode = ""
    @Published var verifiedNums: [String] = []
    //end phone
    
    //Influencer type
    @Published var newProfilePic: UIImage? = nil
    @Published var newBannerImage: UIImage? = nil
    @Published var newDisplayName = ""
    @Published var newTitle = ""
    @Published var newBio = ""
    @Published var matureContent = false
    
    
    //Social Links
    @Published var links: [String: String] =
    [
        "Linkedin":"",
        "Instagram":"",
        "Twitter":"",
        "Soundcloud":"",
        "Spotify":"",
        "Tiktok":"",
        "Pinterest":"",
        "Youtube":"",
        "Twitch":"",
        "Telegram":"",
        "Discord":"",
        "AppleMusic":"",
        "OpenSea":""
    ]
    
    @Published var startLinks: [String : String] = [:] //to test whether anything has changed (for button state)
    
    @Published var userLinks: [SocialMediaUser] = []
        
    //MARK: Edit Profile Functions
    func setEditingFields() {
        //newImage =
        newName = profileManager.profile?.fullname ?? ""
        if newName.trimmingCharacters(in: [" "]) == "" {
            newName = ""
        }
        newUsername = profileManager.profile?.username ?? ""
        newPhone = profileManager.profile?.mobile ?? ""
        newCountry = profileManager.profile?.country ?? ""
        newEmail = profileManager.profile?.email ?? ""
        
        if profileManager.profile?.dob != nil {
            if profileManager.profile?.dob! != "" {
                newDOB = convertDateStringYYYYMMDDToSwiftDate(input: profileManager.profile?.dob ?? "") ?? Date.now
                
                if newDOB != Date.now { newDOBAdded = true }
                else { newDOBAdded = false }
            }
        }
        
        //influencer
        //TODO: when editing title -> do we display a list of all available titles? might have to call backend or create new endpoint for that - or just textfield?
        //or allow user to type in a title, and then when updating, check if it exists, if so, update user.title to that id, if not create it and update?
        if profileManager.profile?.influencer ?? false {
            newTitle = profileManager.profile?.title ?? ""
            newDisplayName = profileManager.profile?.display_name ?? ""
            newBio = profileManager.profile?.bio ?? ""
            matureContent = profileManager.profile?.mature_content ?? false
        }
        
    }
    
    func updateProfile() async throws {
        isLoading = true
        let rqData = (profileManager.profile?.influencer ?? false) ? getRequestDataInfluencer() : getRequestDataRegular()
        
        do {
            try await profileManager.updateProfile(uid: userId, requestData: rqData) { comp in
                if comp != 200 { self.updateError = true }
                self.isLoading = false
            }
        } catch {
            print(error.localizedDescription)
            isLoading = false
            throw error
        }
    }   
    
    func sendVerifyPhone() async throws {
        //set isLoading in this func?
        do {
            let response = try await APIManager().makeAuthedAPICallWithFullUrlGetStatus(url: "\(GlobalVars.APIbaseURL)users/update-phone", httpMethod: "POST", requestData: ["mobile":newPhone])
            
            if response.statusCode == 200 {
                //otp code sent
                sentCode = true
            }
            sentCode = true
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    func updatePhone() async throws {
        //set isLoading in this func?
        do {
            let response = try await APIManager().makeAuthedAPICallWithFullUrlGetStatus(url: "\(GlobalVars.APIbaseURL)users/update-phone", httpMethod: "POST", requestData: ["mobile":newPhone,"otp":otpCode,"user_id":userId])
            
            if response.statusCode == 200 {
                //phone successfully updated
                verifiedNums.append(newPhone)
                sentCode = false
                otpCode = ""
            } else {
                //phone update failed
                //show alert or error msg?
            }
            
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
    
    func getSocialLinks() async throws {
        do {
            isLoading = true
            let response = try await APIManager().makeAuthedAPICallWithFullUrlGetStatus(url: "\(GlobalVars.APIbaseURL)users/influencer/get-social-media/\(profileManager.profile?.id ?? 0)", httpMethod: "GET", requestData: nil)
            let responseSocials = try APIDecoders().decodeSocialMediaAccountsUserResponse(jsonData: response.response ?? "")
            let socials = responseSocials.data ?? []
            for link in socials {
                let newSocial = SocialMediaUser(user_id: link.user_id ?? 0, platform: link.platform ?? "", link: link.link ?? "", id: link.id ?? 0)
                if !userLinks.contains(newSocial) { userLinks.append(newSocial) }
            }
            setLinksFromUserLinks()
            isLoading = false
        } catch {
            print(error.localizedDescription)
            isLoading = false
            throw error
        }
    }
    
    func updateSocialLinks() async throws {
        /*
         schema for bulk update is:
            user_id: int = Field(...)
            socials_data: dict[str, str] = Field(...)
         */
        
        do {
            isLoading = true
            let response = try await APIManager().makeAuthedAPICallWithFullUrlGetStatus(url: "\(GlobalVars.APIbaseURL)users/influencer/social-media-mulitple", httpMethod: "POST", requestData: getRequestDataSocialLink())
            print(response.response ?? "")
            if response.statusCode == 200 {
                startLinks = links
            }
            //then refetch?
            isLoading = false
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
        //TODO: add banner/header pic ujpdart
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
        if newTitle != (profileManager.profile?.title ?? "") { dict["title"] = newTitle }
        if newDisplayName != (profileManager.profile?.display_name ?? "") { dict["display_name"] = newDisplayName }
        if newBio != (profileManager.profile?.bio ?? "") { dict["bio"] = newBio }
        if newEmail != (profileManager.profile?.email ?? "") { dict["email"] = newEmail }
        
        //do date of birth (check newDOBAdded & newDOB != getDate(profile.dob)
        if newDOBAdded {
            let date = convertSwiftDateToDateStringYYYYMMDD(input: newDOB)
            if date != "" {
                dict["dob"] = date
            }
        }
        if newCountry != (profileManager.profile?.country ?? "") { dict["country"] = newCountry }
        if matureContent != (profileManager.profile?.mature_content ?? false) { dict["mature_content"] = matureContent }
        
        return dict
    }
    
    func getRequestDataSocialLink() -> [String : Any] {
        var dict: [String : Any] = [:]
        dict["user_id"] = profileManager.profile?.id ?? 0
        var socials_dict: [String : String] = [:]
        for pair in links {
            if pair.value != "" {
                let formattedLink = getFormattedLink(platform: pair.key, value: pair.value)
                socials_dict[pair.key] = formattedLink
            }
        }
        dict["socials_data"] = socials_dict
        
        return dict
    }
    
    func getFormattedLink(platform: String, value: String) -> String {
        if value.contains("https://www.") || value.contains("http://www.") || value.contains("https://") || value.contains("http://")
            || value.contains("www.") || (value.contains(platform.lowercased()) && value.contains("/"))  {
            return value
        } else {
            switch platform {
            case "Linkedin": return "https://www.linkedin.com/in/\(value.lowercased())/"
            case "Instagram": return "https://www.instagram.com/\(value.lowercased())/"
            case "Twitter": return "https://x.com/\(value.lowercased())"
            case "Soundcloud": return "https://soundcloud.com/\(value.lowercased())"
            case "Spotify": return "https://open.spotify.com/user/\(value.lowercased())"
            case "Tiktok": return "https://www.tiktok.com/@\(value.lowercased())"
            case "Pinterest": return "https://www.pinterest.com/\(value.lowercased())/"
            case "Youtube": return "https://www.youtube.com/@\(value.lowercased())"
            case "Twitch": return "https://www.twitch.tv/\(value.lowercased())/"
            case "Telegram": return "https://t.me/\(value.lowercased())"
            case "Discord": return "https://discord.com/users/\(value.lowercased())"
            case "AppleMusic": return "https://music.apple.com/profile/\(value.lowercased())"
            case "OpenSea": return "https://opensea.io/\(value.lowercased())"
            default:
                return "https://\(platform.lowercased()).com/\(value.lowercased())"
            }
        }
    }
    
    func setLinksFromUserLinks() {
        for link in userLinks {
            if link.platform ?? "" != "" {
                links["\(link.platform ?? "")"] = link.link ?? ""
                print("Set \(link.platform ?? "") to \(link.link ?? "")")
            }
        }
        
        //remove http://, https://, http://www., /https://www., *.com, *.org, *.
        for link in links {
            if link.value.contains("/") {
                let str = links[link.key]?.split(separator: "/").last.map(String.init) ?? links[link.key]
                links[link.key] = str
            }
            
            if link.value.contains("@") {
                let str = links[link.key]?.replacingOccurrences(of: "@", with: "")
                links[link.key] = str
            }
        }
        
        startLinks = links
    }
    
    func saveButtonDisabled() -> Bool { //returns true if button should be disabled
        //TODO: not working fully correct
        //first check if any required field is empty
        if newUsername == "" || newEmail == "" { return true }
        
        if !(profileManager.profile?.influencer ?? false) && newName == "" { return true }
        
        if (profileManager.profile?.influencer ?? false) && newName == "" && newDisplayName == "" { return true }
        
        //phone - todo
        
        //then check if they are the same as existing profile
        if !(profileManager.profile?.influencer ?? false) {
            if (newName == profileManager.profile?.fullname ?? "") && (newUsername == profileManager.profile?.username ?? "") && (newEmail == profileManager.profile?.email ?? "") && (newCountry == profileManager.profile?.country ?? "") && (newDOB == convertDateStringYYYYMMDDToSwiftDate(input: profileManager.profile?.dob ?? "")) { return true }
        } else {
            //TODO -> do same for extra fields
            //copy existing plus add extra fields (display name, pfp & avatar, etc.)
        }
        
        return false
    }
    
    func socialsSaveButtonDisabled() -> Bool {
        //cant determine this because we immediately set the links dictionary to the user profile values and change it when they change it
        
        if links.values.allSatisfy({ val in
            val == ""
        }) { return true }
        
        return startLinks == links
    }
}
