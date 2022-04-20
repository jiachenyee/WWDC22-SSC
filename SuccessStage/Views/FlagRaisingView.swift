//
//  FlagRaisingView.swift
//
//
//  Created by Jia Chen Yee on 13/4/22.
//

import Foundation
import SwiftUI
import SceneKit

enum SuccessStage {
    case _2DScene
    case _3DScene
    case arScene
}

struct FlagRaisingView: View {
    
    var namespace: Namespace.ID
    var code: [Code]
    var flagWidth: CGFloat
    
    @State var flagOffset = 0.0
    @State var flagPoleHeight = 0.0
    let flagHeight = ((200.0 / 3) * 2)
    
    @State var raiseCount = 0
    
    @State var flagImage: UIImage?
    @State var flagContainerView = UIView()
    
    @State var successStage: SuccessStage = ._2DScene
    
    var body: some View {
        ZStack {
            HoldingView(content: FlagView(namespace: nil, code: code, flagWidth: flagWidth, hasShadow: false) .frame(width: flagWidth), view: $flagContainerView)
                .frame(width: flagWidth, height: flagWidth * (2/3))
                .opacity(0)
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                        flagContainerView.backgroundColor = .clear
                        print(flagContainerView.intrinsicContentSize)
                        let renderer = UIGraphicsImageRenderer(size: flagContainerView.bounds.size)
                        flagImage = renderer.image { ctx in
                            flagContainerView.drawHierarchy(in: flagContainerView.bounds, afterScreenUpdates: true)
                        }
                    }
                }
            
            switch successStage {
            case ._2DScene:
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
                            successStage = ._3DScene
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
            case ._3DScene:
                if let flagImage = flagImage {
                    ZStack(alignment: .bottom) {
                        SceneView(flagImage: flagImage)
                            .edgesIgnoringSafeArea(.all)
                        HStack {
                            Button {
                                successStage = .arScene
                            } label: {
                                Label("View in AR", systemImage: "arkit")
                            }
                            .buttonStyle(.borderedProminent)
                            
                            Button {
                                UIImageWriteToSavedPhotosAlbum(flagImage, nil, nil, nil)
                            } label: {
                                Label("Download Flag", systemImage: "photo")
                            }
                            .buttonStyle(.bordered)
                        }
                        .padding()
                    }
                } else {
                    ProgressView()
                }
            case .arScene:
                if let flagImage = flagImage {
                    ZStack(alignment: .bottom) {
                        ARView(flagImage: flagImage)
                            .edgesIgnoringSafeArea(.all)
                        HStack {
                            Button {
                                successStage = ._3DScene
                            } label: {
                                Label("View in 3D", systemImage: "cube")
                            }
                            .buttonStyle(.borderedProminent)
                            
                            Button {
                                UIImageWriteToSavedPhotosAlbum(flagImage, nil, nil, nil)
                            } label: {
                                Label("Download Flag", systemImage: "photo")
                            }
                            .buttonStyle(.bordered)
                        }
                        .padding()
                    }
                } else {
                    ProgressView()
                }
            }
        }
    }
}
