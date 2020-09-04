//
//  TimerViewController.swift
//  SmokerMap
//
//  Created by 정의석 on 2020/03/09.
//  Copyright © 2020 pandaman. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import Charts

class TimerViewController: UIViewController {
    
    var timer = Timer()
    var timeDisplaySecond = 0
    var timeDisplayMinute = 0
    var timeDisplayHour = 0
    var timeDisplayDay = 0
    
    let timeSecondLabel = UILabel()
    let timeMinuteLabel = UILabel()
    let timeHourLabel = UILabel()
    let timeDayLabel = UILabel()
    
    var progressFloat: Float = 0.0
    
    //xd
    let halfBGView = UIView()
    let halfBGImageView = UIImageView()
    let lastWeekLabel = UILabel()
    
    let chartBGView = UIView()
    let chartBGImageView = UIImageView()
    
    let todayBGView = UIView()
    let todayBGImageView = UIImageView()
    let todayLabel = UILabel()
    
    let timerBGView = UIView()
    let timerBGImageView = UIImageView()
    
    let hiddenViewForCenterY = UIView()
    
    let smokeButton = UIButton(type: .system)
    
    //Charts
    let chart = BarChartView()
    
    var daysArr: [String] = []
    
    struct PreviousCigarette {
        let date: String
        let num: Int
    }
    var datas: [PreviousCigarette] = []
    
    
    //Firebase
    var currentTimerTime = 0
    
    let uid = Auth.auth().currentUser?.uid
    let ref = Database.database().reference()
    var cigaretteSmokedToday = 0
    let cigaretteLabel = UILabel()
    
    //progress bar
    let progressBar = UIProgressView(progressViewStyle: .bar)
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        initTodayCigarette()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor(named: "BGcolor")
        checkTodayCigarette()
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkTimeWithFirebase()
    }
    
    private func setupUI() {
        
        
        halfBGImageView.image = UIImage(named: "HalfBG")
        view.addSubview(halfBGView)
        halfBGView.addSubview(halfBGImageView)
        
        
        lastWeekLabel.text = "Last Week"
        lastWeekLabel.textColor = .white
        lastWeekLabel.font = UIFont.systemFont(ofSize: 34, weight: .regular)
        halfBGImageView.addSubview(lastWeekLabel)
        halfBGView.addSubview(chartBGView)
        
        chartBGImageView.image = UIImage(named: "chartBG")
        chartBGView.addSubview(chartBGImageView)
        
        view.addSubview(todayBGView)
        todayBGImageView.image = UIImage(named: "TodaySmokingBG")
        todayBGView.addSubview(todayBGImageView)
        todayLabel.text = "Today"
        todayLabel.font = UIFont.systemFont(ofSize: 26, weight: .light)
        todayBGImageView.addSubview(todayLabel)
        
        progressBar.progressTintColor = .orange
        progressBar.trackTintColor = .white
        progressBar.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        progressBar.progress = Float(cigaretteSmokedToday) * Float(0.05)
        progressBar.layer.cornerRadius = 5
        progressBar.clipsToBounds = true
        
        todayBGImageView.addSubview(progressBar)
        
        view.addSubview(timerBGView)
        timerBGImageView.image = UIImage(named: "TimerBG")
        timerBGView.addSubview(timerBGImageView)
        
        view.addSubview(hiddenViewForCenterY)
        
        timeSecondLabel.textAlignment = .center
        timeMinuteLabel.textAlignment = .center
        timeHourLabel.textAlignment = .center
        timeDayLabel.textAlignment = .center
        timeSecondLabel.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        timeMinuteLabel.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        timeHourLabel.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        timeDayLabel.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        
        timerBGImageView.addSubview(timeSecondLabel)
        timerBGImageView.addSubview(timeMinuteLabel)
        timerBGImageView.addSubview(timeHourLabel)
        timerBGImageView.addSubview(timeDayLabel)
        
        smokeButton.addTarget(self, action: #selector(didTapSmokeButton), for: .touchUpInside)
        smokeButton.setBackgroundImage(UIImage(named: "SmokingButton"), for: .normal)
        view.addSubview(smokeButton)
        
        setupConstraints()
    }
    private func setupConstraints() {
        if self.traitCollection.userInterfaceStyle == .dark {
           
            halfBGView.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.height.equalToSuperview().multipliedBy(0.45)
            }
            halfBGImageView.snp.makeConstraints {
                $0.top.bottom.leading.trailing.equalToSuperview()
            }
            lastWeekLabel.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(35)
            }
            
            chartBGView.snp.makeConstraints {
                $0.top.equalTo(lastWeekLabel.snp.bottom).offset(16)
                $0.centerX.equalToSuperview().offset(6)
                $0.width.equalToSuperview().multipliedBy(0.9)
                $0.height.equalToSuperview().multipliedBy(0.5)
            }
            chartBGImageView.snp.makeConstraints {
                $0.bottom.trailing.equalToSuperview()
                $0.top.equalToSuperview().offset(-8)
                $0.leading.equalToSuperview().offset(-8)
            }
            
            todayBGView.snp.makeConstraints {
                $0.centerY.equalTo(halfBGView.snp.bottom).offset(-25)
                $0.centerX.equalToSuperview().offset(6)
                $0.width.equalToSuperview().multipliedBy(0.9)
                $0.height.equalToSuperview().multipliedBy(0.13)
            }
            todayBGImageView.snp.makeConstraints {
                $0.bottom.trailing.equalToSuperview()
                $0.top.equalToSuperview().offset(-8)
                $0.leading.equalToSuperview().offset(-8)
            }
            todayLabel.snp.makeConstraints {
                $0.top.equalToSuperview().offset(10)
                $0.leading.equalToSuperview().offset(15)
            }
            
            progressBar.snp.makeConstraints {
                $0.top.equalTo(todayLabel.snp.bottom).offset(8)
                $0.leading.equalTo(todayLabel)
                $0.trailing.equalToSuperview().offset(-30)
                $0.height.equalTo(10)
            }
            
            
            
            timerBGView.snp.makeConstraints {
                $0.top.equalTo(todayBGView.snp.bottom)
                $0.centerX.equalToSuperview().offset(6)
                $0.width.equalToSuperview().multipliedBy(0.9)
                $0.height.equalToSuperview().multipliedBy(0.1)
            }
            timerBGImageView.snp.makeConstraints {
                $0.bottom.trailing.equalToSuperview()
                $0.top.equalToSuperview().offset(-8)
                $0.leading.equalToSuperview().offset(-8)
            }
            
            timeMinuteLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(view.snp.centerX)
            }
            
            timeSecondLabel.snp.makeConstraints {
                $0.leading.equalTo(timeMinuteLabel.snp.trailing)
                $0.top.equalTo(timeMinuteLabel)
            }
            
            timeHourLabel.snp.makeConstraints {
                $0.trailing.equalTo(timeMinuteLabel.snp.leading)
                $0.top.equalTo(timeMinuteLabel)
            }
            timeDayLabel.snp.makeConstraints {
                $0.trailing.equalTo(timeHourLabel.snp.leading)
                $0.top.equalTo(timeHourLabel)
            }
            
            
            hiddenViewForCenterY.snp.makeConstraints {
                $0.top.equalTo(timerBGView.snp.bottom)
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                $0.centerX.equalToSuperview().offset(-5)
                $0.width.equalTo(10)
            }
            
            smokeButton.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.centerY.equalTo(hiddenViewForCenterY)
                $0.width.height.equalTo(view.snp.width).multipliedBy(0.45)
            }
        } else {
                  halfBGView.snp.makeConstraints {
                       $0.top.leading.trailing.equalToSuperview()
                       $0.height.equalToSuperview().multipliedBy(0.45)
                   }
                   halfBGImageView.snp.makeConstraints {
                       $0.top.bottom.leading.trailing.equalToSuperview()
                   }
                   lastWeekLabel.snp.makeConstraints {
                       $0.centerX.equalToSuperview()
                       $0.top.equalToSuperview().offset(35)
                   }
                   
                   chartBGView.snp.makeConstraints {
                       $0.top.equalTo(lastWeekLabel.snp.bottom).offset(16)
                       $0.centerX.equalToSuperview().offset(6)
                       $0.width.equalToSuperview().multipliedBy(0.9)
                       $0.height.equalToSuperview().multipliedBy(0.5)
                   }
                   chartBGImageView.snp.makeConstraints {
                       $0.top.bottom.trailing.leading.equalToSuperview()
                   }
                   
                   todayBGView.snp.makeConstraints {
                       $0.centerY.equalTo(halfBGView.snp.bottom).offset(-25)
                       $0.centerX.equalToSuperview().offset(6)
                       $0.width.equalToSuperview().multipliedBy(0.9)
                       $0.height.equalToSuperview().multipliedBy(0.13)
                   }
                   todayBGImageView.snp.makeConstraints {
                       $0.top.bottom.leading.trailing.equalToSuperview()
                   }
                   todayLabel.snp.makeConstraints {
                       $0.top.equalToSuperview().offset(10)
                       $0.leading.equalToSuperview().offset(15)
                   }
                   
                   progressBar.snp.makeConstraints {
                       $0.top.equalTo(todayLabel.snp.bottom).offset(4)
                       $0.leading.equalTo(todayLabel)
                       $0.trailing.equalToSuperview().offset(-30)
                       $0.height.equalTo(10)
                   }
                   
                   
                   
                   timerBGView.snp.makeConstraints {
                       $0.top.equalTo(todayBGView.snp.bottom)
                       $0.centerX.equalToSuperview().offset(6)
                       $0.width.equalToSuperview().multipliedBy(0.9)
                       $0.height.equalToSuperview().multipliedBy(0.1)
                   }
                   timerBGImageView.snp.makeConstraints {
                       $0.top.bottom.leading.trailing.equalToSuperview()
                   }
                   
                   timeMinuteLabel.snp.makeConstraints {
                       $0.centerY.equalToSuperview()
                       $0.leading.equalTo(view.snp.centerX)
                   }
                   
                   timeSecondLabel.snp.makeConstraints {
                       $0.leading.equalTo(timeMinuteLabel.snp.trailing)
                       $0.top.equalTo(timeMinuteLabel)
                   }
                   
                   timeHourLabel.snp.makeConstraints {
                       $0.trailing.equalTo(timeMinuteLabel.snp.leading)
                       $0.top.equalTo(timeMinuteLabel)
                   }
                   timeDayLabel.snp.makeConstraints {
                       $0.trailing.equalTo(timeHourLabel.snp.leading)
                       $0.top.equalTo(timeHourLabel)
                   }
                   
                   
                   hiddenViewForCenterY.snp.makeConstraints {
                       $0.top.equalTo(timerBGView.snp.bottom)
                       $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                       $0.centerX.equalToSuperview().offset(-5)
                       $0.width.equalTo(10)
                   }
                   
                   smokeButton.snp.makeConstraints {
                       $0.centerX.equalToSuperview()
                       $0.centerY.equalTo(hiddenViewForCenterY)
                       $0.width.height.equalTo(view.snp.width).multipliedBy(0.45)
                   }
               }
        
    }
    
    @objc private func timerHandler() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(actionIncreseTime), userInfo: nil, repeats: true)
    }
    
    @objc private func actionIncreseTime() {
        
        if timeDisplayHour == 23 && timeDisplayMinute == 59 && timeDisplaySecond == 59 {
            timeDisplaySecond = 0
            timeDisplayMinute = 0
            timeDisplayHour = 0
            timeDisplayDay += 1
            timeSecondLabel.text = "\(timeDisplaySecond)s"
            timeMinuteLabel.text = "\(timeDisplayMinute)m "
            timeHourLabel.text = "\(timeDisplayHour)h "
            timeDayLabel.text = "\(timeDisplayDay)d "
            currentTimerTime += 86400
        } else if timeDisplayMinute == 59 && timeDisplaySecond == 59 {
            timeDisplaySecond = 0
            timeDisplayMinute = 0
            timeDisplayHour += 1
            timeSecondLabel.text = "\(timeDisplaySecond)s"
            timeMinuteLabel.text = "\(timeDisplayMinute)m "
            timeHourLabel.text = "\(timeDisplayHour)h "
            timeDayLabel.text = "\(timeDisplayDay)d "
            currentTimerTime += 3600
        } else if timeDisplaySecond == 59 {
            timeDisplaySecond = 0
            timeDisplayMinute += 1
            timeSecondLabel.text = "\(timeDisplaySecond)s"
            timeMinuteLabel.text = "\(timeDisplayMinute)m "
            timeHourLabel.text = "\(timeDisplayHour)h "
            timeDayLabel.text = "\(timeDisplayDay)d "
            currentTimerTime += 60
        } else if timeDisplaySecond < 59 {
            timeDisplaySecond += 1
            timeSecondLabel.text = "\(timeDisplaySecond)s"
            timeMinuteLabel.text = "\(timeDisplayMinute)m "
            timeHourLabel.text = "\(timeDisplayHour)h "
            timeDayLabel.text = "\(timeDisplayDay)d "
            currentTimerTime += 1
        }
        
        setupConstraints()
    }
    
    @objc private func didTapSmokeButton() {
        
        currentTimerTime = 0
        
        if timeDisplaySecond == 0 && timeDisplayMinute == 0 && timeDisplayHour == 0 {
            timer.invalidate()
            timerHandler()
        } else {
            timer.invalidate()
            
            timeDisplaySecond = 0
            timeDisplayMinute = 0
            timeDisplayHour = 0
            timeDisplayDay = 0
            
            timeSecondLabel.text = "\(timeDisplaySecond)s"
            timeMinuteLabel.text = "\(timeDisplayMinute)m "
            timeHourLabel.text = "\(timeDisplayHour)h "
            timeDayLabel.text = "\(timeDisplayDay)d "
            timerHandler()
        }
        
        uploadTime() //Upload current time To Firebase When didTapSmokeButton
        uploadTodayCigarette()
        print(cigaretteSmokedToday)
        increseProgress()
        
        //
    }
    
    func uploadTime() {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd G 'at' HH:mm:ss zzz"
        let currentDate = dateFormatter.string(from: now)
        print(currentDate)
        
        let value = ["Started Time": currentDate] as [String:Any]
        ref.child(uid!).child("TimerData").setValue(value) { err, ref in
            if err == nil {
                print("Time upload is complete")
            } else {
                print("Time upload is failed")
            }
        }
    }
    
    func checkTimeWithFirebase() {
        var timeInFirebase: String?
        
        ref.child(uid!).child("TimerData").observeSingleEvent(of: .value) { (data) in
            guard let bigData = data.value as? [String:Any] else { return }
            guard let lastTime = bigData["Started Time"] as? String else {return}
            
            timeInFirebase = lastTime
            print(timeInFirebase)
            let now = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd G 'at' HH:mm:ss zzz"
            guard let startDate = dateFormatter.date(from: lastTime) else {return}
            
            let calendar = Calendar.current
            let dateGap = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: startDate, to: now)
            
            if case let (y?, M?, d?, h?, m?, s?) = (dateGap.year, dateGap.month, dateGap.day, dateGap.hour, dateGap.minute, dateGap.second) {
                
                self.timeDisplayDay = (y * 365) + (M * 30) + (d)
                self.timeDisplayHour = h
                self.timeDisplayMinute = m
                self.timeDisplaySecond = s
                
                self.timeSecondLabel.text = "\(self.timeDisplaySecond)s"
                self.timeMinuteLabel.text = "\(self.timeDisplayMinute)m "
                self.timeHourLabel.text = "\(self.timeDisplayHour)h "
                self.timeDayLabel.text = "\(self.timeDisplayDay)d "
                self.timer.invalidate()
                self.timerHandler()
            }
        }
    }
    
    func checkTodayCigarette() {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let todayStr = dateFormatter.string(from: today)
        
        ref.child(uid!).child("TodayCigarette").child(todayStr).observeSingleEvent(of: .value) { (data) in
            guard let cigaretteNumInFirebase = data.value as? Int else { self.setupUI()
                return }
            //            guard let num = cigaretteNumInFirebase["\(todayStr)"] as? String else { return }
            
            self.cigaretteSmokedToday = cigaretteNumInFirebase
            print("서버에 저장된 담배개비수 :",  self.cigaretteSmokedToday)
            self.setupUI()
            self.makePreviousDays() //챠트
            
            self.saveCigaretteInUD(today: cigaretteNumInFirebase)
            
        }
    }
    
    func saveCigaretteInUD(today: Int) {
        if let groupUserDefaults = UserDefaults(suiteName: "group.smokerMaps") {
            groupUserDefaults.set(today, forKey: "today")
        }
    }
    
    func uploadTodayCigarette() {
        cigaretteSmokedToday += 1
        
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let todayStr = dateFormatter.string(from: today)
        
        let value = cigaretteSmokedToday
        saveCigaretteInUD(today: value)
        
        ref.child(uid!).child("TodayCigarette").child(todayStr).setValue(value) { err, ref in
            if err == nil {
                print("upload complete")
            } else {
                print("fail")
            }
        }
    }
    
    func initTodayCigarette() {
        
           let today = Date()
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyyMMdd"
           let todayStr = dateFormatter.string(from: today)
           
           let value = cigaretteSmokedToday
           saveCigaretteInUD(today: value)
           
           ref.child(uid!).child("TodayCigarette").child(todayStr).setValue(value) { err, ref in
               if err == nil {
                   print("upload complete")
               } else {
                   print("fail")
               }
           }
       }
    
    func increseProgress() {
        let change: Float = 0.05
        self.progressBar.progress = self.progressBar.progress + (change)
    }
    
    func makePreviousDays() {
        let now = Date()
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        let day7 = DateComponents(day: -7)
        let day6 = DateComponents(day: -6)
        let day5 = DateComponents(day: -5)
        let day4 = DateComponents(day: -4)
        let day3 = DateComponents(day: -3)
        let day2 = DateComponents(day: -2)
        let day1 = DateComponents(day: -1)
        
        if let d7 = calendar.date(byAdding: day7, to: now)
        {
            print(dateFormatter.string(from: d7))
            daysArr.append(dateFormatter.string(from: d7))
        }
        if let d6 = calendar.date(byAdding: day6, to: now)
        {
            print(dateFormatter.string(from: d6))
            daysArr.append(dateFormatter.string(from: d6))
        }
        if let d5 = calendar.date(byAdding: day5, to: now)
        {
            print(dateFormatter.string(from: d5))
            daysArr.append(dateFormatter.string(from: d5))
        }
        if let d4 = calendar.date(byAdding: day4, to: now)
        {
            print(dateFormatter.string(from: d4))
            daysArr.append(dateFormatter.string(from: d4))
        }
        if let d3 = calendar.date(byAdding: day3, to: now)
        {
            print(dateFormatter.string(from: d3))
            daysArr.append(dateFormatter.string(from: d3))
        }
        if let d2 = calendar.date(byAdding: day2, to: now)
        {
            print(dateFormatter.string(from: d2))
            daysArr.append(dateFormatter.string(from: d2))
        }
        if let d1 = calendar.date(byAdding: day1, to: now)
        {
            print(dateFormatter.string(from: d1))
            daysArr.append(dateFormatter.string(from: d1))
        }
        
                
        ref.child(uid!).child("TodayCigarette").observeSingleEvent(of: .value) { (data) in
            guard let bigdata = data.value as? [String:Int] else {return}
            
            for i in self.daysArr {
                self.datas.append(PreviousCigarette(date: i, num: bigdata[i] ?? 0))
            }
            self.datas.forEach {
                print("날짜 :", $0.date)
                print("갯수 :", $0.num)
            }
            self.setupCharts()
        }
    }
    
    func setupCharts() {
        let days = datas.map { $0.date }
        let nums = datas.map { $0.num }
        var stringDate = days
        stringDate = stringDate.map({
            var value = $0
            value.removeFirst()
            value.removeFirst()
            value.removeFirst()
            value.removeFirst()
            return value
        })
        customizeChart(dataPoints: days, values: nums, stringDate: stringDate)
    }
    
    func customizeChart(dataPoints: [String], values: [Int], stringDate: [String]) {
        
        chartBGImageView.addSubview(chart)
        
        if self.traitCollection.userInterfaceStyle == .dark {
            chart.snp.makeConstraints {
                $0.top.equalToSuperview().offset(15)
                $0.bottom.equalToSuperview().offset(-15)
                $0.leading.equalToSuperview().offset(10)
                $0.trailing.equalToSuperview().offset(-15)
            }
        // User Interface is Dark
        } else {
            chart.snp.makeConstraints {
                $0.top.equalToSuperview().offset(5)
                $0.bottom.equalToSuperview().offset(-10)
                $0.leading.equalToSuperview()
                $0.trailing.equalToSuperview().offset(-15)
            }
            // User Interface is Light
        }
        
        var dataEntries: [ChartDataEntry] = []
        for i in 1..<8 {
            let dataEntry = BarChartDataEntry(x: Double(i-1), y: Double(values[i-1]))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "How many smoked")
        //        chartDataSet.setColor(NSUIColor.orange)
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        chartData.setDrawValues(true)
                chartDataSet.colors = [UIColor.orange]
         if self.traitCollection.userInterfaceStyle == .dark {
        chart.xAxis.labelTextColor = UIColor.white
            chart.leftAxis.labelTextColor = UIColor.white
            chartData.setValueTextColor(UIColor.white)
            chart.rightAxis.enabled = false
         } else {
            chart.xAxis.labelTextColor = UIColor.black
            chart.leftAxis.labelTextColor = UIColor.black
            chartData.setValueTextColor(UIColor.black)
            chart.rightAxis.enabled = false
        }
//        chartData.setValueTextColor(UIColor.white)
        chart.data = chartData
        chart.setVisibleXRangeMinimum(7.0)
        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: stringDate)
        
    }
}
