//
//  File.swift
//  Time Sheet
//
//  Created by Nguyen Tan Dung on 12/18/19.
//  Copyright © 2019 Nguyen Tan Dung. All rights reserved.
//

import Foundation

struct TimeCheck: Decodable {
    var checkIn: String
    var checkOut: String
    
    init(checkIn:String, checkOut:String) {
        self.checkIn = checkIn
        self.checkOut = checkOut
    }
}

struct DayCeleb: Decodable {
    var day: String
    
    init(day: String) {
        self.day = day
    }
}

struct DayCelebCurrent: Decodable {
    var day: String
    
    init(day: String) {
        self.day = day
    }
}

struct TimeCheckCurrent: Decodable {
    var dayCheckIn:String
    var dayCheckOut:String
    
    init(dayCheckIn:String, dayCheckOut:String) {
        self.dayCheckIn = dayCheckIn
        self.dayCheckOut = dayCheckOut

    }
}

//class TimeChecks: Codable{
//    let timeChecks: [TimeCheck]
//
//    init(timeChecks: [TimeCheck]) {
//        self.timeChecks = timeChecks
//    }
//}


struct DateInfoCheck: Decodable {
    var iso:String
    
    init(iso: String){
        self.iso = iso
    }
}
