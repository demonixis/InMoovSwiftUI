//
//  StartView.swift
//  InMoovSwift
//
//  Created by Yannick Comte on 30/04/2024.
//

import SwiftUI

struct StartView: View {
    var body: some View {
        ZStack {
            VStack {
                Text("InMoov Compagnon App")
                    .font(.title)
                    //.foregroundStyle(.white)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
                Spacer()
            }
            .foregroundStyle(.black)
        }
    }
}

#Preview {
    StartView()
}
