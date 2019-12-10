//
//  ViewController.swift
//  Time Sheet
//
//  Created by Nguyen Tan Dung on 12/9/19.
//  Copyright © 2019 Nguyen Tan Dung. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var yearMonthLabel: UILabel!
    @IBOutlet weak var calendarTable: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!

    let date = Date()
    let dateFormatter = DateFormatter()
    let calendar = Calendar.current
 
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarTable.dataSource = self
        calendarTable.delegate = self
        dateFormatter.dateFormat = "MM/YYYY"
        let dayOfTheWeekString = dateFormatter.string(from: date)
        yearMonthLabel.textAlignment = NSTextAlignment.center
        yearMonthLabel?.text = dayOfTheWeekString
        
        //header and footer
        calendarTable.tableHeaderView = headerView
        headerLabel.textAlignment = NSTextAlignment.center
        headerLabel.text = "Tổng thời gian làm việc: "
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let range = calendar.range(of: .day, in: .month, for: Date())!
        return range.count
        }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = calendarTable.dequeueReusableCell(withIdentifier: "Cell")
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let day = "\(year)-\(month)-\(indexPath.row + 1)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let cellDate = dateFormatter.date(from:day)!
        let cellDateFormatter = DateFormatter()
        cellDateFormatter.dateFormat = "EE"
        let formattedDate = cellDateFormatter.string(from: cellDate)
        switch formattedDate {
        case "Mon":
            cell?.textLabel?.text = "Thứ 2 (ngày \(indexPath.row + 1))"
        case "Tue":
            cell?.textLabel?.text = "Thứ 3 (ngày \(indexPath.row + 1))"
        case "Wed":
            cell?.textLabel?.text = "Thứ 4 (ngày \(indexPath.row + 1))"
        case "Thu":
            cell?.textLabel?.text = "Thứ 5 (ngày \(indexPath.row + 1))"
        case "Fri":
            cell?.textLabel?.text = "Thứ 6 (ngày \(indexPath.row + 1))"
        case "Sat":
            cell?.textLabel?.text = "Thứ 7 (ngày \(indexPath.row + 1))"
        case "Sun":
            cell?.textLabel?.text = "Chủ Nhật (ngày \(indexPath.row + 1))"
        default:
            cell?.textLabel?.text = formattedDate
        }
        
        return cell!
    }
    //Section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Tổng thời gian làm việc: "
    }
    
    //
}

