//
//  JawMechanismServiceView.swift
//  InMoovSwift
//
//  Created by Yannick Comte on 30/04/2024.
//

import Foundation
import SwiftUI

struct JawMechanismServiceView: View {
    @State private var enabled = false
    
    var body: some View {
        Form {
            List {
                Toggle(isOn: $enabled, label: {
                    Text("Enabled")
                })
            }
            .navigationTitle("Jaw Mechanism")
        }
    }
}
