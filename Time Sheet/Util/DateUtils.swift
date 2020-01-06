//
//  DateUtils.swift
//  Time Sheet
//
//  Created by Nguyen Tan Dung on 1/2/20.
//  Copyright © 2020 Nguyen Tan Dung. All rights reserved.
//

import UIKit

class DateUtils {
    static func stringToDate(date: String) -> Date {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormat.date(from: date) ?? Date()
    }
    
    static func stringToDate2(date: String) -> Date {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        return dateFormat.date(from: date) ?? Date()
    }
}
