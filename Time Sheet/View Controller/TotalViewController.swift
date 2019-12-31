//
//  TotalViewController.swift
//  Time Sheet
//
//  Created by Nguyen Tan Dung on 12/9/19.
//  Copyright © 2019 Nguyen Tan Dung. All rights reserved.
//

import UIKit

class TotalViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var monthYearLabel: UILabel!
    @IBOutlet weak var detailTable: UITableView!
    
    var date = Date()
    var date2:String = ""
    let calender = Calendar.current
    var time = [TimeCheck]()
    var currentTimeCheck = [TimeCheckCurrent]()
    var dayWorked = 0
    var totalHour = 0.00
    var totalCheckIn = 0.00
    var totalCheckOut = 0.00

    let monthYearFormat = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTable.delegate = self
        detailTable.dataSource = self
        monthYearFormat.dateFormat = "MMM/yyyy"
        monthYearLabel.text = monthYearFormat.string(from: date)
        parse()
        getTime()
        // Do any additional setup after loading the view.
    }
    @IBAction func backButton(_ sender: Any) {
        let month = calender.component(.month, from: date)
            if month == 1 {
                self.nextButton.isEnabled = true
                self.backButton.isEnabled = false
            }else {
                self.nextButton.isEnabled = true
                self.backButton.isEnabled = true
                date = calender.date(byAdding: .month, value: -1, to: date) ?? date
                self.date2 = monthYearFormat.string(from: date)
                monthYearLabel?.text = self.date2
                totalCheckIn = 0.00
                totalCheckOut = 0.00
                self.dayWorked = 0
                getTime()
                self.detailTable.reloadData()
        }
    }
    
    @IBAction func nextButton(_ sender: Any) {
        let month = calender.component(.month, from: date)
            if month == 12 {
                self.nextButton.isEnabled = false
                self.backButton.isEnabled = true
            }else {
                self.nextButton.isEnabled = true
                self.backButton.isEnabled = true
                date = calender.date(byAdding: .month, value: 1, to: date) ?? date
                self.date2 = monthYearFormat.string(from: date)
                monthYearLabel?.text = self.date2
                totalCheckIn = 0.00
                totalCheckOut = 0.00
                self.dayWorked = 0
                getTime()
                self.detailTable.reloadData()
        }
    }
    
    //parse data
    func parse(){
        let url = Bundle.main.url(forResource: "data", withExtension: "json")
        URLSession.shared.dataTask(with: url!) { data, response, err in
        guard let data = data else {return}
        do{
            let checkTime = try JSONDecoder().decode([TimeCheck].self, from: data)
            self.time = checkTime
            DispatchQueue.main.async {
                self.getTime()
                self.detailTable.reloadData()
            }

        } catch let error as NSError{
            print(error.localizedDescription)
            }
        }.resume()
    }
    
    //get time
    func getTime(){
        let range = calender.range(of: .day, in: .month, for: date)!
        let monthCurrent = calender.component(.month, from: date)
        let yearCurrent = calender.component(.year, from: date)
        let obj = TimeCheckCurrent(dayCheckIn: "", dayCheckOut: "")
        currentTimeCheck = Array(repeating: obj, count: range.count)
        for i in 0..<time.count {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd'T'hh:mm:ss"
            let dateIndex = dateFormat.date(from: time[i].checkIn)
            let monthIndex = calender.component(.month, from: dateIndex!)
            let yearIndex = calender.component(.year, from: dateIndex!)
            let fmtHour = DateFormatter()
            let fmtMinute = DateFormatter()
            let fmtSecond = DateFormatter()
            fmtHour.dateFormat = "HH"
            fmtMinute.dateFormat = "mm"
            fmtSecond.dateFormat = "ss"
            
            if yearIndex == yearCurrent && monthIndex == monthCurrent {
                dayWorked += 1
                let checkIn = dateFormat.date(from: time[i].checkIn)
                print(time[i].checkIn)
                let hourCi = fmtHour.string(from: checkIn ?? Date())
                let minuteCi = fmtMinute.string(from: checkIn ?? Date())
                let secondCi = fmtSecond.string(from: checkIn ?? Date())
                let checkInTime = getHourInt(hourString: hourCi, minuteString: minuteCi, secondsString: secondCi)
                
                let checkOut = dateFormat.date(from: time[i].checkOut)
                print(time[i].checkOut)
                let hourCo = fmtHour.string(from: checkOut ?? Date())
                let minuteCo = fmtMinute.string(from: checkOut ?? Date())
                let secondCo = fmtSecond.string(from: checkOut ?? Date())
                let checkOutTime = getHourInt(hourString: hourCo, minuteString: minuteCo, secondsString: secondCo)
                print("hour: \(hourCi)")
                print("hour: \(hourCo)")
                totalCheckIn = totalCheckIn + checkInTime
                totalCheckOut = totalCheckOut + checkOutTime
                
//                print("\(checkInTime) \(checkOutTime)")
            }
        }
//        print(" final \(totalCheckIn) \(totalCheckOut) \(totalHour)")
        totalHour = (totalCheckOut - totalCheckIn) / 3600
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let range = calender.range(of: .day, in: .month, for: date)!
        return range.count
//        return 10
    }
    
    //convert hour to int
    func getHourInt(hourString: String, minuteString: String, secondsString: String) -> Double {
        let hour = Double(hourString)!
        let minute = Double(minuteString)!
        let second = Double(secondsString)!
        return(hour * 3600 + minute * 60 + second)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = detailTable.dequeueReusableCell(withIdentifier: "Cell")
        let cell = detailTable.dequeueReusableCell(withIdentifier: "DetailTableViewCell")
        let format = DateFormatter()
        format.dateFormat = "MMM dd"
        //get start day and end day of the month
        let components = calender.dateComponents([.year, .month], from: date)
        let startOfMonth = calender.date(from: components)
        let start = format.string(from: startOfMonth ?? date)

        let comps2 = NSDateComponents()
        comps2.month = 1
        comps2.day = -1
        let endDay = calender.date(byAdding: comps2 as DateComponents, to: startOfMonth ?? date)
        let end = format.string(from: endDay ?? date)
        var detailCell:DetailTableViewCell!
        
        if detailCell == nil{
            detailCell = Bundle.main.loadNibNamed("DetailTableViewCell", owner: self, options: nil)?.first as? DetailTableViewCell
        } else {
            detailCell = cell as? DetailTableViewCell
        }
    
        
        
        switch indexPath.item {
        case 0:
            detailCell.detailLabel.text = "peroid: "
            detailCell.timeLabel.text = "\(start) ~ \(end)"
            return detailCell
        case 1:
            detailCell.detailLabel.text = "Day worked: "
            detailCell.timeLabel.text = String(dayWorked)
            return detailCell
        case 2:
            return defaultCell!
        case 3:
            detailCell.detailLabel.text = "Hour worked (Total): "
            detailCell.timeLabel.text = String(totalHour)
            return detailCell
        case 4:
            detailCell.detailLabel.text = "Hour worked (Average): "
            if totalHour == 0 {
                detailCell.timeLabel.text = "0"
            }else{
                let averageHour = totalHour / Double(dayWorked)
                detailCell.timeLabel.text = String(averageHour)
            }
            return detailCell
        case 5:
            return defaultCell!
        case 6:
            detailCell.detailLabel.text = "Overtime (Total): "
            detailCell.timeLabel.text = "0"
            return detailCell
        case 7:
            detailCell.detailLabel.text = "Overtime (Average): "
            detailCell.timeLabel.text = "0"
            return detailCell
        case 8:
            return defaultCell!
        case 9:
            detailCell.detailLabel.text = "Salary (Total): "
            let salary = totalHour * 1000000
            detailCell.timeLabel.text = String(salary)
            return detailCell
        default:
            return defaultCell!
        }
    }
}
