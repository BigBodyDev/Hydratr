//
//  ChangeRemindersText.swift
//  Hydratr
//
//  Created by Devin Green on 4/16/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct ChangeRemindersText: View {
    var text: String
    var subtext: String
    
    var body: some View {
        HStack(alignment: .bottom){
            Text(text)
                .font(.system(size: 100))
                .fontWeight(.bold)
            Text(subtext)
                .font(.headline)
                .font(.system(size: 30))
                .padding(.bottom, 25)
        }
    }
}

struct ChangeRemindersText_Previews: PreviewProvider {
    static var previews: some View {
        ChangeRemindersText(text: "60", subtext: "minutes")
    }
}
