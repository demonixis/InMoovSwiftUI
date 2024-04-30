//
//  ContentView.swift
//  InMoovSwift
//
//  Created by Yannick Comte on 24/04/2024.
//

import SwiftUI
import Network

struct ContentView: View {
    @State private var selelectedTab = "start"
    
    var body: some View {
        TabView (selection: $selelectedTab) {
            StartView()
                .tabItem {
                    Label("Robot", systemImage: "bolt.circle")
                }
                .tag("start")
                        
            BrainView()
                .tabItem {
                    Label("Brain", systemImage: "brain.head.profile")
                }
                .tag("brain")
            
            ServoMixerView()
                .tabItem {
                    Label("Servos Mixer", systemImage: "list.dash")
                }
                .tag("mixer")
            
            ServiceView()
                .tabItem {
                    Label("Services", systemImage: "gear")
                }
                .tag("services")
                        
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "slider.horizontal.3")
                }
                .tag("settings")
        }
    }
}

#Preview {
    ContentView()
}
