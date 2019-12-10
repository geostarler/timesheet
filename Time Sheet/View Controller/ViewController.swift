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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = calendarTable.dequeueReusableCell(withIdentifier: "Cell")
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let day = "\(year)-\(month)-\(indexPath.row + 1)"
        
        //show day of the month
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let cellDate = dateFormatter.date(from:day)!
        let cellDateFormatter = DateFormatter()
        cellDateFormatter.locale = Locale(identifier: "vi_VN")
        cellDateFormatter.dateFormat = "EEEE"
        let formattedDate = cellDateFormatter.string(from: cellDate)
        cell?.textLabel?.text = formattedDate
        
        
        return cell!
    }
    //Solution 1: Section title
    //Solution 2: Use 3 sections, section one and three will show total, section two will show all date of month
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Tổng thời gian làm việc: "
        }else if section == 2{
            return "Tổng thời gian làm việc: "
        }
        return "Ngày:"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
      }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let range = calendar.range(of: .day, in: .month, for: Date())!
        if section == 0 {
            return 1
        } else if section == 2 {
            return 1
        }
        return range.count + 2
        }

}

