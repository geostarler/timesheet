//
//  TestObject.swift
//  Time Sheet
//
//  Created by Nguyen Tan Dung on 12/18/19.
//  Copyright © 2019 Nguyen Tan Dung. All rights reserved.
//

import UIKit

class TestObject: NSObject {

    var title: String = ""
    var desc: String!
    var count: Int = -1
    
    override init() {
        super.init()
        title = "title"
        desc = "dafdd"
        count = 2
    }
    
    init(title: String, des: String, count: Int) {
        self.title = title
        self.desc = des
        self.count = count
    }
    
    init(obj: TestObject) {
        self.title = obj.title
        self.desc = obj.desc
        self.count = obj.count
    }
}
