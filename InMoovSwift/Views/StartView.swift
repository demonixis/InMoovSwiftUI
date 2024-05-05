//
//  StartView.swift
//  InMoovSwift
//
//  Created by Yannick Comte on 30/04/2024.
//

import SwiftUI

struct StartView: View {
    @ObservedObject private var bluetooth = BluetoothManager.shared
    
    var body: some View {
        ZStack {
            Image("InMoovBG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .offset(CGSize(width: -60.0, height: 10.0))
                .frame(height: 450)
            
            VStack {
                Text("InMoov Compagnon App")
                    .font(.title)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .centerFirstTextBaseline)
                    .padding(.top, 10)
                
                HStack {
                    Text("Bluetooth")

                       Circle()
                           .foregroundColor(bluetooth.isConnected ? .green : .red)
                           .frame(width: 20, height: 20)
                }
        
                Spacer()
                Spacer()
            }
        }
    }
}

#Preview {
    StartView()
}
