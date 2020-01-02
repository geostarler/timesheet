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
    var totalCheck = 0.00
    var overTime = 0.00
    var overTimeCheck = 0.00
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
        let monthCurrent = calender.component(.month, from: date)
        let yearCurrent = calender.component(.year, from: date)
        totalCheck = 0.00
        dayWorked = 0
        overTime = 0.00
        for i in 0..<time.count {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let dateIndex = dateFormat.date(from: time[i].checkIn)
            let monthIndex = calender.component(.month, from: dateIndex!)
            let yearIndex = calender.component(.year, from: dateIndex!)
            if yearIndex == yearCurrent && monthIndex == monthCurrent {
                dayWorked += 1
                let checkIn = dateFormat.date(from: time[i].checkIn)
                let checkOut = dateFormat.date(from: time[i].checkOut)
                let timeOftheDay = checkOut?.timeIntervalSince(checkIn ?? Date())
                totalCheck = totalCheck + timeOftheDay!
                if timeOftheDay! > 9.00{
                    overTimeCheck = overTime + (timeOftheDay! - 9.00)
                }
            }
        }
        totalHour = totalCheck / 3600
        overTime = overTimeCheck / 3600
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
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
            if dayWorked == 0 {
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
            detailCell.timeLabel.text = "\(overTime)"
            return detailCell
        case 7:
            detailCell.detailLabel.text = "Overtime (Average): "
            if dayWorked == 0{
                detailCell.timeLabel.text = "0"
            } else {
                let averageOT = overTime / Double(dayWorked)
                detailCell.timeLabel.text = "\(averageOT)"
            }
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
