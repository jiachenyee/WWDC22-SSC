//
//  SwiftUIView.swift
//  
//
//  Created by Jia Chen Yee on 11/4/22.
//

import SwiftUI

struct AngleView: View {
    
    @Binding var rotation: Angle
    
    var body: some View {
        GeometryReader { context in
            ZStack {
                Circle()
                    .stroke(lineWidth: 15)
                    .opacity(0.1)
                Button {
                    if Double(Int(round(rotation.degrees)) % 15) >= 7.5 {
                        rotation = .degrees(ceil(rotation.degrees / 15) * 15)
                    } else {
                        rotation = .degrees(floor(rotation.degrees / 15) * 15)
                    }
                } label: {
                    ZStack {
                        Circle()
                            .trim(from: 0, to: 0.1)
                            .stroke(style: .init(lineWidth: 15, lineCap: .round, lineJoin: .round))
                            .rotation(.degrees(270 - 18))
                        Circle()
                            .trim(from: 0, to: 0.1)
                            .stroke(style: .init(lineWidth: 15, lineCap: .round, lineJoin: .round))
                            .rotation(.degrees(270 - 18 - 180))
                    }
                    .rotationEffect(rotation)
                }
                .highPriorityGesture(RotationGesture()
                    .onChanged({ angle in
                        rotation = angle
                    }))
                Text("\(Int(round(rotation.degrees)))°")
            }
            .foregroundColor(.blue)
            .padding(15)
        }
    }
}
struct AngleView_Previews: PreviewProvider {
    static var previews: some View {
        AngleView(rotation: .constant(.zero))
    }
}
