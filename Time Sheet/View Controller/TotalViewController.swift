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
    let monthYearFormat = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTable.delegate = self
        detailTable.dataSource = self
        monthYearFormat.dateFormat = "MM,YYYY"
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailTable.dequeueReusableCell(withIdentifier: "DetailTableViewCell")
        var detailCell:DetailTableViewCell!
        if detailCell == nil{
            detailCell = Bundle.main.loadNibNamed("DetailTableViewCell", owner: self, options: nil)?.first as? DetailTableViewCell
        } else {
            detailCell = cell as? DetailTableViewCell
        }
        switch indexPath.section {
        case 0:
            switch indexPath.row {
                case 0:
                    detailCell.detailLabel.text = "Check in: "
                    detailCell.timeLabel.text = "08:30"
                case 1:
                    detailCell.detailLabel.text = "Check out: "
                    detailCell.timeLabel.text = "17:30"
                detailCell.timeLabel.text = "08:00"
                case 2:
                    detailCell.detailLabel.text = "Break: "
                    detailCell.timeLabel.text = "00:00"
                default:
                    detailCell.detailLabel.text = "Pause: "
                    detailCell.timeLabel.text = "00:00"
                }
            return detailCell
        case 1:
            detailCell.detailLabel.text = ""
            detailCell.timeLabel.text = "08:00"
            return detailCell
        default:
            detailCell.detailLabel.text = ""
            detailCell.timeLabel.text = "17:00"
            return detailCell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            return "HOURS WORKED "
        case 1:
            return "MEMO"
        case 2:
            return ""
        default:
            return ""
        }
    }

}
