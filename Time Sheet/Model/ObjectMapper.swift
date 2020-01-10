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

struct HolidayResponse: Mappable {
    
    var response:Holidays?
        init(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {

        response <- map["response"]
       
    }
}

struct Holidays: Mappable {
    var holidays:[HolidayDetail]?
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        holidays <- map["holidays"]
    }
}

struct HolidayDetail: Mappable {
    var date:DateInfo?
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        date <- map["date"]
    }

}
struct DateInfo: Mappable {
    var iso:String?
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        iso <- map["iso"]
    }
}

