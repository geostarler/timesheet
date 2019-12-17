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

    var date = Date()
    var date2:String = ""
    let monthFormatter = DateFormatter()
    let calendar = Calendar.current
    
    var checkInTime = [String]()
    var checkOutTime = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarTable.dataSource = self
        calendarTable.delegate = self
        yearMonthLabel.textAlignment = NSTextAlignment.center
        monthFormatter.dateFormat = "MM/YYYY"
        date2 = monthFormatter.string(from: date)
        yearMonthLabel?.text = "\(date2)"
        parse()
        //header and footer
//        calendarTable.tableHeaderView = headerView
//        headerLabel.textAlignment = NSTextAlignment.center
//        headerLabel.text = "Tổng thời gian làm việc: "
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
            cellDefault?.textLabel?.textAlignment = NSTextAlignment.center
            return cellDefault!
        case 1:
            let queue = DispatchQueue(label: "loadTime")
            cell.dayLabel.text = "\(formattedDate)"
            let dateFm = DateFormatter()
            dateFm.dateFormat = "yyyy-MM-dd"
            dateFm.locale = Locale(identifier: "vi_VN")
            let formattedDate2 = dateFm.string(from: cellDate)
            //get time
            queue.async {
                for i in self.checkInTime {
                    for j in self.checkOutTime {
                        let fmt1 = DateFormatter()
                        fmt1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        let fmt2 = fmt1.date(from: i) ?? cellDate
                        let fmt3 = fmt1.date(from: j) ?? cellDate
                        let fmt = DateFormatter()
                        let getTime = DateFormatter()
                        getTime.dateFormat = "HH:mm:ss"
                        fmt.dateFormat = "yyyy-MM-dd"
                        let fmti = fmt.string(from: fmt2)
                        let timeGettedI = getTime.string(from: fmt2)
                        let timeGettedJ = getTime.string(from: fmt3)
                        DispatchQueue.main.async {
                            if formattedDate2 == fmti {
                                cell.checkinLabel.text = timeGettedI
                                cell.checkoutLabel.text = timeGettedJ
                            }
                        }
                    }
                }
            }
            return cell
        default:
            cellDefault?.textLabel?.text = "Tổng thời gian làm việc: "
            cellDefault?.textLabel?.textAlignment = NSTextAlignment.center
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
        
//        let range = calendar.range(of: .day, in: .month, for: date)!
//        let dateComponents = DateComponents(year: year, month: .month)
//        let calendar = Calendar.current
//        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        if section == 0 {
            return 1
        } else if section == 2 {
            return 1
        }
        
        return numDays
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
            self.calendarTable.reloadData()
        }
       
    }
    
    //next button
    @IBAction func nextButton(_ sender: Any) {
        let month = calendar.component(.month, from: date)
        if month == 12 {
            self.nextButton.isEnabled = false
            self.backButton.isEnabled = true
        }else {
            self.nextButton.isEnabled = true
            self.backButton.isEnabled = true
            date = calendar.date(byAdding: .month, value: 1, to: date) ?? date
            date2 = monthFormatter.string(from: date)
            yearMonthLabel?.text = date2
            self.calendarTable.reloadData()
        }
    }
    
    //parse data
    func parse(){
        let url = Bundle.main.url(forResource: "data", withExtension: "json")
        if let url = url {
            let data = try? Data(contentsOf: url)
            do{
                guard let data = data
                    else {return}
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                guard let dataArray = json as? [Any] else {return}
                for time in dataArray {
                    guard let timeList = time as? [String: Any] else {return}
                    guard let checkin = timeList["checkIn"] as? String else {return}
                    checkInTime.append(checkin)
                    guard let checkout = timeList["checkOut"] as? String else {return}
                    checkOutTime.append(checkout)
                }
            }
            
            catch let error as NSError{
                print(error.localizedDescription)
            }
        }
    }
}

