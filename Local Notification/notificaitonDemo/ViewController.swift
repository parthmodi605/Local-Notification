//
//  ViewController.swift
//  notificaitonDemo
//
//  Created by Tops on 05/12/17.
//  Copyright © 2017 Tops. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: 100)
    
        //print("\(h):\(m):\(s)")
    }

    @IBOutlet weak var lbltimeleft: UILabel!
    var seconds = 0
    
    var timer = Timer()
    
    @IBAction func setNotification(_ sender: UIButton) {
        
        let cal = Calendar(identifier: .gregorian)
        
        var component = 	cal.dateComponents(in: .current, from: datePicker.date)
        
        var newcomponent = DateComponents(calendar: cal, timeZone: .current, era: component.era, year: component.year, month: component.month, day: component.day, hour: component.hour, minute: component.minute, second: component.second, nanosecond: component.nanosecond, weekday: component.weekday, weekdayOrdinal: component.weekdayOrdinal, quarter: component.quarter, weekOfMonth: component.weekOfMonth, weekOfYear: component.weekOfYear, yearForWeekOfYear: component.yearForWeekOfYear)
        
        print(newcomponent)
        newcomponent.calendar = cal
        
        //let trigger = UNCalendarNotificationTrigger(dateMatching: newcomponent, repeats: false)
        
        
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.subtitle = "Date : \(newcomponent.year!)-\(newcomponent.month!)-\(newcomponent.day!), Time \(newcomponent.hour!):\(newcomponent.minute!):\(newcomponent.second!)"
        content.body = "You need to relax!"
        content.categoryIdentifier = "UnKnown"
        
        
        let imageName = "programmer"
        guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png") else { return }
        
        let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
        
        content.attachments = [attachment]
        
        
        var elapsed = Date().timeIntervalSince(datePicker.date)
        print(elapsed)
        if elapsed < 0{
            elapsed *= -1
        }
        
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: Int(elapsed))
        seconds = Int(elapsed)
        
        lbltimeleft.text = "\(h):\(m):\(s)"
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeleftshow), userInfo: nil, repeats: true)
        

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: elapsed ,
            repeats: false)
        //print(datePicker.countDownDuration.)
        let request = UNNotificationRequest(
            identifier: "identifier",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        timer.fire()
        
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func timeleftshow() {
        
        if seconds == 0{
            timer.invalidate()
        }else{
            seconds -= 1
            let (h,m,s) = secondsToHoursMinutesSeconds(seconds: seconds)
            
            lbltimeleft.text = "\(h):\(m):\(s)"
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

