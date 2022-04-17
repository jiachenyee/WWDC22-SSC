//
//  FlagRaisingView.swift
//
//
//  Created by Jia Chen Yee on 13/4/22.
//

import Foundation
import SwiftUI
import SceneKit

struct FlagRaisingView: View {
    
    var namespace: Namespace.ID
    var code: [Code]
    var flagWidth: CGFloat
    
    @State var flagOffset = 0.0
    @State var flagPoleHeight = 0.0
    let flagHeight = ((200.0 / 3) * 2)
    
    @State var raiseCount = 0
    @State var showSceneKitView = false
    
    let scene = SCNScene(named: "FlagPole.scn")!
    
    var body: some View {
        if showSceneKitView {
            SceneView(scene: scene,
                      options: .allowsCameraControl)
        } else {
            VStack {
                Text("You did it!")
                    .font(.headline)
                    .padding()
                
                GeometryReader { context in
                    HStack(alignment: .bottom, spacing: 0) {
                        Rectangle()
                            .frame(width: 20)
                        FlagView(namespace: namespace, code: code, flagWidth: flagWidth)
                            .frame(width: 200)
                            .offset(y: flagOffset)
                            .onChange(of: context.size.height) { _ in
                                flagPoleHeight = context.size.height
                            }
                            .onAppear {
                                flagPoleHeight = context.size.height
                            }
                    }
                    .matchedGeometryEffect(id: "flagpole", in: namespace)
                }
                .frame(width: 220)
                
                Button("Raise") {
                    if raiseCount >= 10 {
                        showSceneKitView = true
                    } else {
                        withAnimation {
                            flagOffset -= (flagPoleHeight - flagHeight) / 10
                        }
                    }
                    raiseCount += 1
                    
                }
                .buttonStyle(.borderedProminent)
                .matchedGeometryEffect(id: "raiseButton", in: namespace)
                .padding()
            }
        }
    }
}
