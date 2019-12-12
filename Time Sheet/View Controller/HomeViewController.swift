//
//  HomeViewController.swift
//  Time Sheet
//
//  Created by Nguyen Tan Dung on 12/9/19.
//  Copyright © 2019 Nguyen Tan Dung. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var nameViewLabel: UILabel!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    
    @IBOutlet weak var checkinButton: UIButton!
    @IBOutlet weak var checkoutButton: UIButton!
    
    let timeFormatter = DateFormatter()
    let dateFormatter = DateFormatter()
    var status:Bool = true
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set time
        timeFormatter.dateFormat = "EE, yyyy-MM-dd"
        dateLabel.text = timeFormatter.string(from: Date())
        dateFormatter.dateFormat = "HH:mm"
        clockLabel.text = dateFormatter.string(from: Date())
    }
     
//    override func viewDidAppear(_ animated: Bool) {
//        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        timer.invalidate()
//    }
//
//    @objc func onTimerFires()
//    {
//        NSLog("")
//        dateFormatter.dateFormat = "HH:mm"
//        clockLabel.text = dateFormatter.string(from: Date())
//    }
    
    //check in button
    @IBAction func checkinButton(_ sender: Any) {
        if status {
            self.checkoutButton.isHidden = false
            self.checkinButton.setTitle("Tạm Dừng", for: .normal)
            self.viewLabel.text = "Check in: (\(clockLabel.text ?? "") \(dateLabel.text ?? ""))"
        }else {
            self.checkinButton.setTitle("Tiếp tục", for: .normal)
            self.checkoutButton.isHidden = true
            self.viewLabel.text = "Tạm dừng: (\(clockLabel.text ?? "") \(dateLabel.text ?? ""))"
        }
        status = !status
    }
    //check out button
    @IBAction func checkoutButton(_ sender: Any) {
        self.checkoutButton.isHidden = true
        self.checkinButton.setTitle("Check In", for: .normal)
        self.viewLabel.text = "Check out: (\(clockLabel.text ?? "") \(dateLabel.text ?? ""))"
        self.status = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
