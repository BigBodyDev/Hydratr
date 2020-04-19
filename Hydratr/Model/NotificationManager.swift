//
//  NotificationManager.swift
//  Hydratr
//
//  Created by Devin Green on 4/17/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging

struct Notification {
    var id: String
    var title: String
}

class NotificationManager: NSObject, UNUserNotificationCenterDelegate, MessagingDelegate {
    static let shared = NotificationManager()
    private var notificationCenter = UNUserNotificationCenter.current()
    
    override init() {
        super.init()
        
        notificationCenter.delegate = self
        Messaging.messaging().delegate = self
        
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                self.requestPermission()
            }else{
                self.scheduleNotifications()
            }
        }
        
    }
    
    func initialize() {}
    
    private func notificationComponents(fromDate date: Date) -> DateComponents{
        return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    }
    
    func requestPermission(){
        notificationCenter.requestAuthorization(options: [.alert, .badge, .alert]) { granted, error in
            if granted == true && error == nil {
                self.scheduleNotifications()
            }
        }
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func scheduleNotifications() {
        unscheduleNotifications {
            DispatchQueue.main.async {
                for reminder in ReminderManager.shared.reminders{
                    let content = UNMutableNotificationContent()
                    content.body = "DRINK WATER"
                    content.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
                    
                    var triggerDate: Date{
                        var date = reminder.time.underlyingDate
                        let now = Date()
                        while date <= now{
                            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                        }
                        return date
                    }
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: self.notificationComponents(fromDate: triggerDate), repeats: false)
                    let request = UNNotificationRequest(identifier: String(ReminderManager.shared.reminders.firstIndex(of: reminder)!), content: content, trigger: trigger)
                    
                    self.notificationCenter.add(request)
                }
            }
        }
        
    }
    
    func unscheduleNotifications( _ completionHandler: (() -> Void)?){
        notificationCenter.getPendingNotificationRequests { (requests) in
            var identifiers = [String]()
            for request in requests{
                identifiers.append(request.identifier)
            }
            self.notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
            completionHandler?()
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
    }
    
    func removeDeliveredNotifications(){
        notificationCenter.removeAllDeliveredNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
}
