//
//  ReminderEditHost.swift
//  Hydratr
//
//  Created by Devin Green on 4/16/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct ReminderEditHost: View {
    @EnvironmentObject var reminderManager: ReminderManager
    @Binding var isPresented: Bool
    
    @State var timeText: String
    @State var start: Date
    @State var max: Date
    
    @State var showError: Bool = false
    @State var errorMessage: String = String()
    
    var saveButton: some View {
        Button(action: {
            
            if Time(self.start) >= Time(self.max){
                self.errorMessage = "Please enter a valid start and max time range"
                self.showError.toggle()
            }else if String(self.reminderManager.timeInterval / 60) != self.timeText
                || self.reminderManager.startTime.underlyingDate != self.start
                || self.reminderManager.maxTime.underlyingDate != self.max{
                
                if let time = Int(self.timeText){
                    if time <= 60{
                        self.reminderManager.timeInterval = time * 60
                        self.reminderManager.startTime = Time(self.start)
                        self.reminderManager.maxTime = Time(self.max)
                        
                        
                        self.reminderManager.createNewReminders {
                            self.isPresented = false
                        }
                    }else{
                        self.errorMessage = "Please enter a time interval between 0 and 60"
                        self.showError.toggle()
                    }
                }else{
                    self.errorMessage = "Please enter a valid time interval"
                    self.showError.toggle()
                }
                
            
            }else{
                self.isPresented = false
            }
        }) {
            Spacer()
            Text("Save")
        }
    }
    
    var body: some View {
        
        let startTime = Time(start)
        let maxTime = Time(max)
        
        return NavigationView{
            ZStack{
                GradientView()
                    .edgesIgnoringSafeArea(.all)
                Form{
                    Section {
                        HStack(alignment: .bottom){
                            TextField("30", text: $timeText)
                                .keyboardType(.numberPad)
                                .font(.system(size: 100, weight: .bold))
                                .frame(width: 140)
                            Text("minutes")
                                .font(.headline)
                                .font(.system(size: 30))
                                .padding(.bottom, 25)
                        }
                    }
                    Section {
                        ChangeRemindersText(text: startTime.stringNoHrPeriod, subtext: startTime.hrPeriod)
                        DatePicker(selection: $start, displayedComponents: .hourAndMinute) {
                            Text("Reminders must start at:")
                        }
                    }
                    Section {
                        ChangeRemindersText(text: maxTime.stringNoHrPeriod, subtext: maxTime.hrPeriod)
                        DatePicker(selection: $max, displayedComponents: .hourAndMinute) {
                            Text("Reminders must stop before:")
                        }
                    }
                }
                .padding(.top, 1)
                .clipped()
                
            }.navigationBarTitle(Text("Change Reminders"))
            .navigationBarItems(trailing: saveButton)
        }.alert(isPresented: $showError) { () -> Alert in
            Alert(title: Text("Woah there buddy"), message: Text(self.errorMessage), dismissButton: .default(Text("Ight")))
        }
        
    }
}

struct ReminderEditHost_Previews: PreviewProvider {
    static var previews: some View {
        ReminderEditHost(isPresented: .constant(false), timeText: "60", start: Date(), max: Date())
        .environmentObject(ReminderManager())
    }
}
