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
    let monthFormatter = DateFormatter()
    let calendar = Calendar.current
    var month = 0
    var year = 2019
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarTable.dataSource = self
        calendarTable.delegate = self
        month = calendar.component(.month, from: date)
        yearMonthLabel.textAlignment = NSTextAlignment.center
        yearMonthLabel?.text = "\(month)/\(year)"
        
        //header and footer
//        calendarTable.tableHeaderView = headerView
//        headerLabel.textAlignment = NSTextAlignment.center
//        headerLabel.text = "Tổng thời gian làm việc: "
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDefault = calendarTable.dequeueReusableCell(withIdentifier: "Cell")
        
        let year = calendar.component(.year, from: date)
        let day = "\(year)-\(month)-\(indexPath.row + 1)"
        //get data from custom cell
        let customCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")
        var cell:TableViewCell!
        if customCell == nil{
            cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as? TableViewCell
        } else {
            cell = customCell as? TableViewCell
        }
        
        //show day of the month
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let cellDate = dateFormatter.date(from:day)!
        let cellDateFormatter = DateFormatter()
        cellDateFormatter.locale = Locale(identifier: "vi_VN")
        cellDateFormatter.dateFormat = "EEEE"
        let formattedDate = cellDateFormatter.string(from: cellDate)
//        if indexPath.section == 0 {
//            cell?.textLabel?.text = "Tổng thời gian làm việc: "
//        }else if indexPath.section == 2{
//            cell?.textLabel?.text = "Tổng thời gian làm việc: "
//        }else if indexPath.section == 1 {
//            cell?.textLabel?.text = formattedDate
//        }
        switch indexPath.section {
        case 0:
            cellDefault?.textLabel?.text = "Tổng thời gian làm việc: 40 tiếng"
            return cellDefault!
        case 1:
            cell.dayLabel.text = formattedDate
            cell.checkinLabel.text = "8:00"
            cell.checkoutLabel.text = "17:30"
            return cell
        default:
            cellDefault?.textLabel?.text = "Tổng thời gian làm việc: "
            return cellDefault!
        }
    }
    //Solution 1: Section title
    //Solution 2: Use 3 sections, section one and three will show total, section two will show all date of month
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0{
//            return "Tổng thời gian làm việc: "
//        }else if section == 2{
//            return "Tổng thời gian làm việc: "
//        }
//        return "Ngày:"
//    }
    
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
    return range.count
    }
    
    //back button
    @IBAction func backButton(_ sender: Any) {
        if self.month == 1 {
            self.backButton.isEnabled = false
            self.nextButton.isEnabled = true
        }else {
            self.backButton.isEnabled = true
            self.nextButton.isEnabled = true
            self.month -= 1
            self.yearMonthLabel.text = "\(self.month)/\(self.year)"
            self.calendarTable.reloadData()
        }
       
    }
    
    //next button
    @IBAction func nextButton(_ sender: Any) {
        if self.month == 12 {
            self.nextButton.isEnabled = false
            self.backButton.isEnabled = true
        }else {
            self.nextButton.isEnabled = true
            self.backButton.isEnabled = true
            self.month += 1
            self.yearMonthLabel.text = "\(self.month)/\(self.year)"
            self.calendarTable.reloadData()
        }
    }
}

