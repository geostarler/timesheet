//
//  ObjectMapper.swift
//  Time Sheet
//
//  Created by Nguyen Tan Dung on 1/3/20.
//  Copyright © 2020 Nguyen Tan Dung. All rights reserved.
//

import Foundation
import ObjectMapper


struct CheckTime: Mappable {

    var checkIn: String?
    var checkOut: String?
    
    init?(map: Map){
        
    }
    
    
     mutating func mapping(map: Map) {
        checkIn <- map["checkIn"]
        checkOut <- map["checkOut"]
    }
    
}

class HolidayResponse: Mappable {
    var meta: String?
//    var response:[Holidays]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        meta <- map["meta.code"]
//        response <- map["response"]
    }
}
//struct Holidays: Mappable {
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//        holidays <- map["holidays"]
//    }
//
//    var holidays:[HolidayDetail]?
//}
//struct HolidayDetail: Mappable {
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//        name <- map["name"]
//        date <- map["date"]
//    }
//
//    var name:String?
//    var date:DateInfo?
//}
//struct DateInfo: Mappable {
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//        iso <- map["iso"]
//    }
//
//    var iso:String?
//}
//
