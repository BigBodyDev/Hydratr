//
//  MainHost.swift
//  Hydratr
//
//  Created by Devin Green on 4/14/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

enum ActiveSheet {
   case reminderEdit, bottle
}

struct MainHost: View {
    @EnvironmentObject var reminderManager: ReminderManager
    @State var showSheet: Bool = false
    @State var activeSheet: ActiveSheet = .reminderEdit
    
    var stack: some View{
        VStack {
            HStack{
                Button(action: {
                    
                    self.reminderManager.toggleRemindersActive(nil)
                }) {
                    Image(systemName: self.$reminderManager.remindersActive.wrappedValue ? "pause.fill" : "play.fill")
                        .imageScale(.large)
                }
                .padding(.top, 30)
                .padding(.leading, 30)
                
                Spacer()
                
                Button(action: {
                    
                    self.activeSheet = .bottle
                    self.showSheet.toggle()
                }) {
                    Image(systemName: "dot.radiowaves.left.and.right")
                        .imageScale(.large)
                }
                .padding(.top, 30)
                .padding(.trailing, 30)
            }
            
            
            VStack(spacing: 15){
                Spacer()
                    .frame(height: 50)
                Text("Remind me to drink water every:")
                    .font(.headline)
                HStack(alignment: .bottom){
                    Text(String(reminderManager.timeInterval / 60))
                        .font(.system(size: 60))
                        .fontWeight(.bold)
                    Text("minutes")
                        .font(.headline)
                        .padding(.bottom, 10)
                        .padding(.leading, 0)
                }
                Button(action: {
                    self.activeSheet = .reminderEdit
                    self.showSheet.toggle()
                }) {
                    Text("Click here to change reminders")
                        .font(.headline)
                }
                Spacer()
                    .frame(height: 50)
            }
            
            List(reminderManager.reminders, id: \.id){ reminder in
                ReminderRow(reminder: reminder)
            }
        }
        
    }
    
    var body: some View {
        ZStack(alignment: .bottom){
            withAnimation(.easeInOut(duration: 0.5)) {
                GradientView()
                    .transition(AnyTransition.opacity.animation(.linear(duration: 0.5)))
            }
            if self.reminderManager.loaded{
                withAnimation(.easeInOut(duration: 0.5)) {
                    stack
                        .transition(AnyTransition.opacity.animation(.linear(duration: 0.25)))
                }
            }else{
                withAnimation(.easeInOut(duration: 0.5)) {
                    stack
                        .hidden()
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $showSheet) {
            if self.activeSheet == .reminderEdit{
                ReminderEditHost(isPresented: self.$showSheet, timeText: String(self.reminderManager.timeInterval / 60), start: self.reminderManager.startTime.underlyingDate, max: self.reminderManager.maxTime.underlyingDate)
                .environmentObject(self.reminderManager)
            }else if self.activeSheet == .bottle{
                HydratrHost(isPresented: self.$showSheet)

            }
        }
    }
}

struct MainHost_Previews: PreviewProvider {
    static var previews: some View {
        MainHost()
            .environmentObject(ReminderManager.shared)
    }
}
