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
                NavigationLink(destination: DemonstrationServiceView(), label: {
                    Text("Demonstration Mode")
                })
                
                NavigationLink(destination: JawMechanismServiceView(), label: {
                    Text("Jaw Mechanism")
                })
            }
            .navigationTitle("Services")
        }
    }
}
