//
//  File.swift
//  
//
//  Created by Jia Chen Yee on 12/4/22.
//

import Foundation
import SwiftUI

struct FlagView: View {
    
    var namespace: Namespace.ID?
    var code: [Code]
    var flagWidth: CGFloat
    
    var hasShadow = true
    
    var body: some View {
        GeometryReader { context in
            ZStack {
                Color.white
                    .shadow(color: .black.opacity(hasShadow ? 0.1 : 0), radius: 16)
                FlagRendererView(code: code)
            }
            .aspectRatio(3/2, contentMode: .fit)
            .frame(width: flagWidth, height: (flagWidth / 3) * 2)
            .scaleEffect(context.size.width / flagWidth, anchor: .topLeading)
        }
        .aspectRatio(3/2, contentMode: .fit)
        .modifier(CustomMatchedGeometryEffect(id: "flag", namespace: namespace))
    }
}

struct CustomMatchedGeometryEffect: ViewModifier {
    var id: String
    var namespace: Namespace.ID?
    
    func body(content: Content) -> some View {
        if let namespace = namespace {
            content.matchedGeometryEffect(id: id, in: namespace)
        } else {
            content
        }
    }
}
