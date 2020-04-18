//
//  ReminderManager.swift
//  Hydratr
//
//  Created by Devin Green on 4/16/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseDatabase

class ReminderManager: ObservableObject {
    @Published var loaded: Bool = false
    @Published var reminders = [WaterReminder]()
    @Published var timeInterval: Int = 0
    @Published var startTime: Time = Time(Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!)
    @Published var maxTime: Time = Time(Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date())!)
    
    init(timeInterval: Int, startTime: Time, maxTime: Time, reminders: [WaterReminder]){
        self.timeInterval = timeInterval
        self.startTime = startTime
        self.maxTime = maxTime
        self.reminders = reminders
    }
    
    
    init(){
        var managerLoaded = false{
            didSet{
                checkLoaded()
            }
        }
        var remindersLoaded = false{
            didSet{
                checkLoaded()
            }
        }
        
        func checkLoaded(){
            if managerLoaded && remindersLoaded{
                self.loaded = true
            }
        }
        
        Database.database().reference().child("Manager_Data").observe(.value) { snapshot in
            if let data = snapshot.value as? Dictionary<String, Any>{
                if let timeInterval = data["time_interval"] as? Int{
                    self.timeInterval = timeInterval
                }
                
                if let startString = data["start_time"] as? String{
                    self.startTime = Time(startString)
                }
                
                if let maxString = data["max_time"] as? String{
                    self.maxTime = Time(maxString)
                }
            }
            
            managerLoaded = true
        }
        Database.database().reference().child("Reminders").observe(.value) { snapshot in
            self.reminders.removeAll()

            var reminders = [WaterReminder]()

            if let values = snapshot.value as? [Dictionary<String, Any>] {
                for value in values{
                    var id = String()
                    var time = Time()

                    if let _id = value["id"] as? String{
                        id = _id
                    }
                    if let timeString = value["time"] as? String{
                        time = Time(timeString)
                    }
                    let reminder = WaterReminder(id: id, time: time)
                    reminders.append(reminder)
                }
            }

            func sortedReminderArray(reminders: [WaterReminder]) -> [WaterReminder]{
                return reminders.sorted(by: { (first, second) -> Bool in
                    first.time < second.time
                })
            }
            self.reminders = sortedReminderArray(reminders: reminders)
            
            remindersLoaded = true
        }
    }
    
    func createNewReminders(_ completionHandler: (() -> Void)?){
        self.reminders.removeAll()
        var time = startTime
        while time <= maxTime {
            self.reminders.append(WaterReminder(time: time))
            time = time.timeByAddingTimeInterval(TimeInterval(timeInterval))
        }
        save(completionHandler)
    }
    
    func toJSON() -> Dictionary<String, Any>{
        var remindersJson = [Dictionary<String, Any>]()
        for reminder in self.reminders{
            remindersJson.append(reminder.toJSON())
        }
        let json: Dictionary<String, Any> = [
            "Manager_Data": [
                "time_interval": timeInterval,
                "start_time": startTime.dateString,
                "max_time": maxTime.dateString,
            ],
            "Reminders": remindersJson
        ]
        return json
    }
    
    func save(_ completionHandler: (() -> Void)?){
        Database.database().reference().setValue(self.toJSON()) { (error, reference) in
            print(reference.description())
            completionHandler?()
        }
    }
}
