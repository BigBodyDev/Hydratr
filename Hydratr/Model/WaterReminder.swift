//
//  WaterReminder.swift
//  Hydratr
//
//  Created by Devin Green on 4/16/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import Foundation

class WaterReminder: Identifiable, Equatable  {
    var id: UUID
    var time: Time
    
    init(id: String, time: Time){
        self.id = UUID(uuidString: id)!
        self.time = time
    }
    
    init(time: Time) {
        self.id = UUID()
        self.time = time
    }
    
    func toJSON() -> Dictionary<String, Any>{
        let json: Dictionary<String, Any> = ["id": self.id.uuidString, "time": self.time.dateString]
        return json
    }
    
    static func ==(lhs: WaterReminder, rhs: WaterReminder) -> Bool {
        return lhs.time == rhs.time
    }
}

extension WaterReminder {
    static func TEST() -> WaterReminder {
        let reminder = WaterReminder(time: Time())
        return reminder
    }
}
