//
//  ViewController.swift
//  Time Sheet
//
//  Created by Nguyen Tan Dung on 12/9/19.
//  Copyright © 2019 Nguyen Tan Dung. All rights reserved.
//

import UIKit
import ObjectMapper

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var yearMonthLabel: UILabel!
    @IBOutlet weak var calendarTable: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!

    var date = Date()
    var date2:String = ""
    let monthFormatter = DateFormatter()
    let calendar = Calendar.current

    var totalCheck = 0.00
    var totalHour = 0.00
    var time = [CheckTime]()
    var dayCl = [Holiday]()
    var dayClCheck = [DayCelebCurrent]()
    var currentTimeCheck = [TimeCheckCurrent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarTable.dataSource = self
        calendarTable.delegate = self
        yearMonthLabel.textAlignment = NSTextAlignment.center
        monthFormatter.dateFormat = "MM/yyyy"
        date2 = monthFormatter.string(from: date)
        yearMonthLabel?.text = "\(date2)"
        parse()
        parse2()
        getDay()
        getTime()
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellDefault = calendarTable.dequeueReusableCell(withIdentifier: "Cell")
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
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
        let cellDate = DateUtils.stringToDate2(date: day)
        let cellDateFormatter = DateFormatter()
        cellDateFormatter.locale = Locale(identifier: "vi_VN")
        cellDateFormatter.dateFormat = "EE"
        let cellDateFormatter2 = DateFormatter()
        cellDateFormatter2.locale = Locale(identifier: "vi_VN")
        cellDateFormatter2.dateFormat = "(MM/dd)"
        let formattedDate = cellDateFormatter.string(from: cellDate)
        let formattedDate2 = cellDateFormatter2.string(from: cellDate)
        switch indexPath.section {
        case 0:
            cellDefault?.textLabel?.text = "Tổng thời gian làm việc: \(totalHour)"
            cellDefault?.textLabel?.textAlignment = NSTextAlignment.center
            return cellDefault!
        case 1:
            //get time
            cell.dayLabel.text = "\(formattedDate)"
            cell.dateLabel.text = "\(formattedDate2)"
            if cell.dayLabel.text == "CN" || cell.dayLabel.text == "Th 7" {
                cell.dayLabel.textColor = UIColor.red
                cell.dateLabel.textColor = UIColor.red
            }
            let fmtDisplayDate = DateFormatter()
            fmtDisplayDate.dateFormat = "(MM/dd)"
            let holidayDate = DateUtils.stringToDate2(date: dayClCheck[indexPath.row].day)
            if dayClCheck[indexPath.row].day != "" {
                let holiday = fmtDisplayDate.string(from: holidayDate)
                if cell.dateLabel.text == "\(holiday)"{
                    cell.dayLabel.textColor = UIColor.red
                    cell.dateLabel.textColor = UIColor.red
                }
            }
            let fmtDisplay = DateFormatter()
            fmtDisplay.dateFormat = "HH:mm:ss"
            if currentTimeCheck[indexPath.row].dayCheckIn != "" && currentTimeCheck[indexPath.row].dayCheckOut != "" {
                let checkIn = DateUtils.stringToDate(date: currentTimeCheck[indexPath.row].dayCheckIn)
                cell.checkinLabel.text = fmtDisplay.string(from: checkIn)
                let checkOut = DateUtils.stringToDate(date: currentTimeCheck[indexPath.row].dayCheckOut)
                cell.checkoutLabel.text = fmtDisplay.string(from: checkOut)
            } else {
                cell.checkinLabel.text = ""
                cell.checkoutLabel.text = ""
            }
            return cell
        default:
            cellDefault?.textLabel?.text = "Tổng thời gian làm việc: \(totalHour) "
            cellDefault?.textLabel?.textAlignment = NSTextAlignment.center
            return cellDefault!
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
      }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        if section == 0 {
            return 1
        } else if section == 2 {
            return 1
        }
        return numDays
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let month = calendar.component(.month, from: date)
        if month == 1 {
            self.backButton.isEnabled = false
            self.nextButton.isEnabled = true
        }else if month == 12 {
            self.backButton.isEnabled = true
            self.nextButton.isEnabled = false
        }
    }
    
    //back button
    @IBAction func backButton(_ sender: Any) {
        let month = calendar.component(.month, from: date)
        if month == 1 {
            self.backButton.isEnabled = false
            self.nextButton.isEnabled = true
        }else {
            self.backButton.isEnabled = true
            self.nextButton.isEnabled = true
            date = calendar.date(byAdding: .month, value: -1, to: date) ?? date
            date2 = monthFormatter.string(from: date)
            yearMonthLabel?.text = date2
            getDay()
            getTime()
            self.calendarTable.reloadData()
        }
        if month == 2 {
            self.backButton.isEnabled = false
            self.nextButton.isEnabled = true
        }
    }
    
    //next button
    @IBAction func nextButton(_ sender: Any) {
        let month = calendar.component(.month, from: date)
        if month == 12 {
            self.nextButton.isEnabled = false
            self.backButton.isEnabled = true
        }
        else {
            self.nextButton.isEnabled = true
            self.backButton.isEnabled = true
            date = calendar.date(byAdding: .month, value: 1, to: date) ?? date
            date2 = monthFormatter.string(from: date)
            yearMonthLabel?.text = date2
            getDay()
            getTime()
            self.calendarTable.reloadData()
        }
        if month == 11 {
            self.nextButton.isEnabled = false
            self.backButton.isEnabled = true
        }
    }
    
    //parse data
    func parse(){
        time = Mapper<CheckTime>().mapArray(JSONfile: "data.json")!
    }
    func parse2(){
        dayCl = Mapper<Holiday>().mapArray(JSONfile: "dayCeleb.json")!
    }
    //ObjectMapper
    
    
    func getTime(){
        let range = calendar.range(of: .day, in: .month, for: date)!
        let monthCurrent = calendar.component(.month, from: date)
        let yearCurrent = calendar.component(.year, from: date)
        let obj = TimeCheckCurrent(dayCheckIn: "", dayCheckOut: "")
        currentTimeCheck = Array(repeating: obj, count: range.count)
        totalCheck = 0.00
        for i in 0..<time.count {
            let dateIndex = DateUtils.stringToDate(date: time[i].checkIn!)
            let dayIndex = calendar.component(.day, from: dateIndex)
            let monthIndex = calendar.component(.month, from: dateIndex)
            let yearIndex = calendar.component(.year, from: dateIndex)
            if yearIndex == yearCurrent && monthIndex == monthCurrent {
                currentTimeCheck[dayIndex - 1].dayCheckIn = time[i].checkIn!
                currentTimeCheck[dayIndex - 1].dayCheckOut = time[i].checkOut!
                let checkIn = DateUtils.stringToDate(date: time[i].checkIn!)
                let checkOut = DateUtils.stringToDate(date: time[i].checkOut!)
                totalCheck = totalCheck + (checkOut.timeIntervalSince(checkIn))
            }
        }
        totalHour = totalCheck / 3600
    }
    
    func getDay(){
        let range = calendar.range(of: .day, in: .month, for: date)!
        let monthCurrent = calendar.component(.month, from: date)
        let yearCurrent = calendar.component(.year, from: date)
        let obj = DayCelebCurrent(day: "")
        dayClCheck = Array(repeating: obj, count: range.count)
        for i in 0..<dayCl.count {
            let dateIndex = DateUtils.stringToDate2(date: dayCl[i].day!)
            let dayIndex = calendar.component(.day, from: dateIndex)
            let monthIndex = calendar.component(.month, from: dateIndex)
            let yearIndex = calendar.component(.year, from: dateIndex)
            if yearIndex == yearCurrent && monthIndex == monthCurrent {
                dayClCheck[dayIndex - 1].day = dayCl[i].day!
            }
        }
    }
}

