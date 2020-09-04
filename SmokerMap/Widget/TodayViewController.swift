//
//  TodayViewController.swift
//  Widget
//
//  Created by 정의석 on 2020/03/12.
//  Copyright © 2020 pandaman. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var todayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabel()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        setLabel()
    }
    
    func setLabel() {
        if let todayCigarette = UserDefaults(suiteName: "group.smokerMaps") {
            todayLabel.text = "\(todayCigarette.integer(forKey: "today"))  cigarettes today"
            if todayLabel.text == "0  cigarettes today" {
                todayLabel.text = "0  cigarette today"
            } else if todayLabel.text == "1  cigarettes today" {
                todayLabel.text = "1  cigarette today"
            }
        }
        
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
