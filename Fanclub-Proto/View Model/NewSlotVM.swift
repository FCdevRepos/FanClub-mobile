//
//  NewSlotVM.swift
//  Fanclub-Proto
//
//  Created by Austin Moca on 3/20/26.
//
import SwiftUI

class NewSlotVM: ObservableObject {
    @Published var monthSel = Calendar.current.dateComponents([.month], from: Date.now).month ?? 1
    @Published var yearSel = Calendar.current.dateComponents([.year], from: Date.now).year ?? 0
    
    @Published var timeHour = 12
    @Published var timeMin = 00
    @Published var ampm = "AM"
    
    @Published var meetingDate: Date = Date.now
    
    @Published var slotDuration = 5.0   //[5,10,15,20,25,30,35,40,45,50,55,60])
    @Published var intervalDuration = 2.0
    @Published var coins = 0.0
    @Published var priceOfCoins = 0.0
    
    @Published var irl = false
    
    func getIntervalSteps() -> [Double] {
        //interval step 0 or total duration -> total duration
        //otherwise must be a divisor of total duration
        var ret: [Double] = []
            
        
        //return list of all divisors of slot duration
        if slotDuration == 5 { ret = [5] }
        else {
            for i in 1...Int(slotDuration) {
                if Int(slotDuration) % i == 0 && (Int(i) % 5 == 0) { //must be a multiple of 5 for an interval
                    ret.append(Double(i))
                }
            }
        }
        
        //ret must be > 0
        return ret
    }
}
