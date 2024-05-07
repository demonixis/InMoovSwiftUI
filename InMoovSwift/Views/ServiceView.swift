//
//  ServiceView.swift
//  InMoovSwift
//
//  Created by Yannick Comte on 28/04/2024.
//

import SwiftUI
import Network

struct ServiceView: View {
    var body: some View {
        
        NavigationStack {
            List {
                Section("Main") {
                    NavigationLink(destination: BluetoothServiceView(), label: {
                        Text("Connections")
                    })
                    
                    NavigationLink(destination: ServoMixerView(), label: {
                        Text("Servo Mixer")
                    })
                }
                
                Section("Secondary") {
                    NavigationLink(destination: DemoWifiServiceView(), label: {
                        Text("Demonstration Mode (Wifi)")
                    })
                    
                    NavigationLink(destination: JawMechanismServiceView(), label: {
                        Text("Jaw Mechanism")
                    })
                }
            }
            .navigationTitle("Services")
        }
    }
}

#Preview {
    ServiceView()
}
