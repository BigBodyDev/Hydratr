//
//  ReminderRow.swift
//  Hydratr
//
//  Created by Devin Green on 4/16/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct ReminderRow: View {
    @EnvironmentObject var reminderManager: ReminderManager
    var reminder: WaterReminder
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            HStack {
                HStack(alignment: .bottom, spacing: 5) {
                    Text(reminder.time.stringNoHrPeriod)
                        .font(.largeTitle)
                        .foregroundColor(reminderManager.remindersActive ? .primary : .secondary)
                    
                    Text(reminder.time.hrPeriod)
                        .font(.headline)
                        .padding(.bottom, 5)
                        .foregroundColor(reminderManager.remindersActive ? .primary : .secondary)
                }
                Spacer()
                Text("Reminder \((reminderManager.reminders.firstIndex(of: reminder) ?? 0)  + 1)")
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
    }
}

struct ReminderRow_Previews: PreviewProvider {
    static var previews: some View {
        ReminderRow(reminder: WaterReminder.TEST())
        .environmentObject(ReminderManager())
    }
}
