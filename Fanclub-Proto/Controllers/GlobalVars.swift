//
//  Global.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 9/10/24.
//

import Foundation
import SwiftUI
import UIKit

class GlobalVars {
    
//    public static let let APIbaseURL = "https://python-backend-development.up.railway.app/api/v1/"
//    public static let APIbaseURL = "http://localhost:8081/api/v1/"
    public static let APIbaseURL = "http://10.0.0.191:8081/api/v1/"
//    public static let APIbaseURL = "http://192.168.2.84:8081/api/v1/"
    
    public static let textColor = Color(red: 185/255, green: 185/255, blue: 185/255)
    
    public static let purpleColor = UIColor(red: 240/255, green: 103/255, blue: 240/255, alpha: 100/100)
    
    public static let PurpleButtonColor = Color(red: 144/255, green: 72/255, blue: 209/255)
    public static let GrayButtonColor = Color(red: 53/255, green: 53/255, blue: 53/255)
    
    public static let YellowText = Color(red: 243/255, green: 233/255, blue: 77/255)
    
//    public static let ViewBackgroundColor

    public static let creatorCategories = [
        "Photographer","Podcaster","Videographer","Athlete","Gamer","Coach","Performer","Artist","Musician",
        "Entertainer","Author","Character","Producer","Model","Social Media Personality","Public Figure",
    ]
    
    public static let months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    
    public static let SettingsLinks: [[String]] =
    //title, type, action tag, color?
    [
        ["Purchase Club Coins","Popup","club_coins",""],
        ["Invite Code Management","Page","invite_code",""],
        ["Share Invite Code","Popup","invite_code_share",""],
        ["Get Profile Link","Popup","profile_link",""],
        ["View Subscription Plan Settings","Page","subsc_plan",""],
        ["Paid DMs Plan Settings","Page","paid_dms",""],
        ["Payouts","Popup","payouts",""],
        ["Link Bank Account","Page","bank_link",""],
        ["App Settings","Page","settings",""],
        ["Block List","Page","blocked",""],
        ["Create a Club","Page","create_club",""],
        ["Create NFT","Webpage","nft_create",""],
        ["Upload NFT","Webpage","nft_upload",""],
        ["Crypto Wallet","Page","crypto",""],
        ["Request Merch","Webpage","merch",""],
        ["Display NFTs","Webpage","nft_connect",""],
        ["Create Your Own Site","Webpage","create_site",""],
        ["AI Tools","Webpage","AI",""],
        ["Contact Support","Email","contact",""],
        ["Delete My Account","","delete","red"],
        ["Logout","","logout","yellow"]
    ]
    
    public static let countries: [String] =
    [
        "Afghanistan",
        "Åland Islands",
        "Albania",
        "Algeria",
        "Andorra",
        "Angola",
        "Anguilla",
        "Antarctica",
        "Antigua & Barbuda",
        "Argentina",
        "Armenia",
        "Aruba",
        "Ascension Island",
        "Australia",
        "Austria",
        "Azerbaijan",
        "Bahamas",
        "Bahrain",
        "Bangladesh",
        "Barbados",
        "Belarus",
        "Belgium",
        "Belize",
        "Benin",
        "Bermuda",
        "Bhutan",
        "Bolivia",
        "Bosnia & Herzegovina",
        "Botswana",
        "Bouvet Island",
        "Brazi",
        "British Indian Ocean Territory",
        "British Virgin Islands",
        "Brunei",
        "Bulgaria",
        "Burkina Faso",
        "Burundi",
        "Cambodia",
        "Cameroon",
        "Canada",
        "Cape Verde",
        "Caribbean Netherlands",
        "Cayman Islands",
        "Central African Republic",
        "Chad",
        "Chile",
        "China",
        "Colombia",
        "Comoros",
        "Congo - Brazzaville",
        "Congo - Kinshasa",
        "Cook Islands",
        "Costa Rica",
        "Côte d'Ivoire",
        "Croatia",
        "Curaçao",
        "Cyprus",
        "Czechia",
        "Denmark",
        "Djibouti",
        "Dominica",
        "Dominican Republic",
        "Ecuador",
        "Egypt",
        "El Salvador",
        "Equatorial Guinea",
        "Eritrea",
        "Estonia",
        "Eswatini",
        "Ethiopia",
        "Falkland Islands",
        "Faroe Islands",
        "Fiji",
        "Finland",
        "France",
        "French Guinea",
        "French Polynesia",
        "French Southern Territories",
        "Gabon",
        "Gambia",
        "Georgia",
        "Germany",
        "Ghana",
        "Gibraltar",
        "Greece",
        "Greenland",
        "Grenada",
        "Guadaloupe",
        "Guam",
        "Guatemala",
        "Guernsey",
        "Guinea",
        "Guinea-Bissau",
        "Haiti",
        "Honduras",
        "Honk Kong SAR China",
        "Hungary",
        "Iceland",
        "India",
        "Indonesia",
        "Iraq",
        "Ireland",
        "Isle of Man",
        "Israel",
        "Italy",
        "Jamaica",
        "Japan",
        "Jersey",
        "Jordan",
        "Kazakhstan",
        "Kenya",
        "Kiribati",
        "Kosovo",
        "Kuwait",
        "Kyrgyzstan",
        "Laos",
        "Latvia",
        "Lebanon",
        "Lesotho",
        "Liberia",
        "Libya",
        "Liechtenstein",
        "Lithuania",
        "Luxembourg",
        "Macao SAR China",
        "Madagascar",
        "Malawi",
        "Malaysia",
        "Maldvies",
        "Mali",
        "Malta",
        "Martinique",
        "Mauritania",
        "Mauritius",
        "Mayotte",
        "Mexico",
        "Moldova",
        "Monaco",
        "Mongolia",
        "Montenegro",
        "Montserrat",
        "Morocco",
        "Mozambique",
        "Myanmar (Burma)",
        "Namibia",
        "Mauru",
        "Nepal",
        "Netherlands",
        "New Caledonia",
        "New Zealand",
        "Nicaragua",
        "Niger",
        "Nigeria",
        "Niu",
        "North Macedonia",
        "Norway",
        "Oman",
        "Pakistan",
        "Palestinian Territories",
        "Panama",
        "Papa New Guinea",
        "Paraguay",
        "Peru",
        "Philippines",
        "Pitcairn Islands",
        "Poland",
        "Portugal",
        "Puerto Rico",
        "Qatar",
        "Réunion",
        "Romania",
        "Russia",
        "Rwanda",
        "Samoa",
        "San Marino",
        "São Tomé & Príncipe",
        "Saudi Arabia",
        "Senegal",
        "Serbia",
        "Seychelles",
        "Sierra Leone",
        "Singapore",
        "Sint Maarten",
        "Slovakia",
        "Slovenia",
        "Solomon Islands",
        "Somalia",
        "South Africa",
        "South Georgia & South Sandwich Islands",
        "South Korea",
        "South Sudan",
        "Spain",
        "Sri Lanka",
        "St. Barthélemy",
        "St. Helena",
        "St. Kitts & Nevis",
        "St. Lucia",
        "St. Pierre & Miquelon",
        "St. Vincent & Grenadines",
        "Sudan",
        "Suriname",
        "Svalbard & Jan Mayen",
        "Sweden",
        "Switzerland",
        "Taiwan",
        "Tajikistan",
        "Tanzania",
        "Thailand",
        "Timor-Leste",
        "Togo",
        "Tokelau",
        "Tonga",
        "Trinidad & Tobago",
        "Tristan da Cunha",
        "Tunisia",
        "Türkiye",
        "Turkmenistan",
        "Turks & Caicos Islands",
        "Tuvalu",
        "Uganda",
        "Ukraine",
        "United Arab Emirates",
        "United Kingdom",
        "United States",
        "Uruguay",
        "Vanuatu",
        "Vatican City",
        "Venezuela",
        "Vietnam",
        "Wallis & Futuna",
        "Western Sahara",
        "Yemen",
        "Zambia",
        "Zimbabwe"
    ]
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct DisableSwipeBack: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                DisableSwipeBackView()
            )
    }
}

struct DisableSwipeBackView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        Controller()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    class Controller: UIViewController {
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
}

extension View {
    func disableSwipeBack() -> some View {
        modifier(DisableSwipeBack())
    }
}


//MARK: extra unused code for when scrollview content is empty and we want to display something/text in the middle
//ScrollView {
//    ZStack {
//        Spacer().containerRelativeFrame([.horizontal, .vertical])
//        VStack {
//            //put content that you want in the middle of the scrollview here
//        }
//    }
//}
