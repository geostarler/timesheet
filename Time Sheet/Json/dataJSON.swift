//
//  File.swift
//  Time Sheet
//
//  Created by Nguyen Tan Dung on 12/18/19.
//  Copyright © 2019 Nguyen Tan Dung. All rights reserved.
//

import Foundation

struct TimeCheck: Decodable {
    let checkIn: String
    let checkOut: String
    
    init(checkIn:String, checkOut:String) {
        self.checkIn = checkIn
        self.checkOut = checkOut
    }
}

//class TimeChecks: Codable{
//    let timeChecks: [TimeCheck]
//
//    init(timeChecks: [TimeCheck]) {
//        self.timeChecks = timeChecks
//    }
//}
