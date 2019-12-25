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
    
    var checkInTime:[String] = []
    var checkOutTime:[String] = []
    var currentCheckInTime : [String] = []
    var currentCheckOutTime : [String] = []
    let monthYearFormat = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTable.delegate = self
        detailTable.dataSource = self
        monthYearFormat.dateFormat = "MMM,YYYY"
        monthYearLabel.text = monthYearFormat.string(from: date)
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
                self.detailTable.reloadData()
        }
    }
    
    //parse data

    
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
        switch indexPath.row {
        case 0:
            detailCell.detailLabel.text = "peroid: "
            detailCell.timeLabel.text = "\(start) ~ \(end)"
            return detailCell
        case 1:
            detailCell.detailLabel.text = "Day worked: "
            detailCell.timeLabel.text = "8 days"
            return detailCell
        case 2:
            return defaultCell!
        case 3:
            detailCell.detailLabel.text = "Hour worked (Total): "
            detailCell.timeLabel.text = "100:00"
            return detailCell
        case 4:
            detailCell.detailLabel.text = "Hour worked (Average): "
            detailCell.timeLabel.text = "08:00"
            return detailCell
        case 5:
            return defaultCell!
        case 6:
            detailCell.detailLabel.text = "Overtime (Total): "
            detailCell.timeLabel.text = "10:00"
            return detailCell
        case 7:
            detailCell.detailLabel.text = "Overtime (Average): "
            detailCell.timeLabel.text = "1:00"
            return detailCell
        case 8:
            return defaultCell!
        case 9:
            detailCell.detailLabel.text = "Salary (Total): "
            detailCell.timeLabel.text = "999999999"
            return detailCell
        default:
            return defaultCell!
        }
    }
}
