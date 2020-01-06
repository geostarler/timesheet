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

struct Holiday: Mappable {

    var day: String?
    
    init?(map: Map){
        
    }

     mutating func mapping(map: Map) {
        day <- map["day"]
    }
    
}
