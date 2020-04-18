//
//  HydratrHost.swift
//  Hydratr
//
//  Created by Devin Green on 4/17/20.
//  Copyright © 2020 Devin Green. All rights reserved.
//

import SwiftUI

struct HydratrHost: View {
    @ObservedObject var bluetooth: BluetoothViewer = BluetoothViewer.shared
    @Binding var isPresented: Bool
    var body: some View {
        let proximityValues = [
            "The Hydratr is in immediate proximity",
            "The Hydratr is nearby",
            "The Hydratr is far away",
            "Bluetooth is off",
            "Bluetooth connections are unauthorized with this device",
            "Bluetooth connections are unsupported with this device",
            "This device's bluetooth connection is resetting",
            "This device or it's peripheral has run into a bluetooth connection error"
        ]
        
        let imageNames = [
            "Immediate",
            "Near",
            "Far",
            "Off",
            "Unauthorized.Unsupported.Resetting",
            "Unauthorized.Unsupported.Resetting",
            "Unauthorized.Unsupported.Resetting",
            "Unknown"
        ]
        
        return NavigationView {
            GeometryReader { geometry in
                ZStack{
                    GradientView()
                    VStack{
                        Image(imageNames[self.bluetooth.hydratrProximity.rawValue])
                            .resizable()
                            .aspectRatio(contentMode: ContentMode.fit)
                    VStack(spacing: 10){
                        Text("Hydratr Status:")
                            .font(.headline)
                        Text(proximityValues[self.bluetooth.hydratrProximity.rawValue])
                            .font(.caption)
                    }.padding()
                    }
                }.navigationBarTitle(Text("Hydratr Bottle"))
            }
            
        }
    }
}

struct BottleHost_Previews: PreviewProvider {
    static var previews: some View {
        HydratrHost(isPresented: .constant(true))
    }
}
