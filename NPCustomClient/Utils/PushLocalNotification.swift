//
//  PushLocalNotification.swift
//  NPCustomClient
//
//  Created by Denis Markov on 8/1/19.
//  Copyright © 2019 Denis Markov. All rights reserved.
//

import UIKit
import UserNotifications

class LocalNotification {
    
    static func push(title: String, description: String, identifier: String) {
        
        let content = UNMutableNotificationContent()
        
        content.title = title
        content.body = description
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let identifier = identifier
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
}



