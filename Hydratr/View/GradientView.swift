//
//  GradientView.swift
//  Hydratr
//
//  Created by Devin Green on 4/16/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct GradientView: View {
    var body: some View {
        
        let colors = Gradient(colors: [.blue, Color.blue.opacity(0)])
        let gradient = LinearGradient(gradient: colors, startPoint: .bottom, endPoint: .top)
        
        return GeometryReader { geometry in
            VStack{
                Spacer()
                Rectangle()
                    .fill(gradient)
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}

struct GradientView_Previews: PreviewProvider {
    static var previews: some View {
        GradientView()
    }
}
