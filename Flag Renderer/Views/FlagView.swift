//
//  File.swift
//  
//
//  Created by Jia Chen Yee on 12/4/22.
//

import Foundation
import SwiftUI

struct FlagView: View {
    
    var namespace: Namespace.ID
    var code: [Code]
    var flagWidth: CGFloat
    
    var body: some View {
        GeometryReader { context in
            ZStack {
                Color.white
                    .shadow(color: .black.opacity(0.1), radius: 16)
                FlagRendererView(code: code)
            }
            .aspectRatio(3/2, contentMode: .fit)
            .frame(width: flagWidth, height: (flagWidth / 3) * 2)
            .scaleEffect(context.size.width / flagWidth, anchor: .topLeading)
        }
        .aspectRatio(3/2, contentMode: .fit)
        .matchedGeometryEffect(id: "flag", in: namespace)
    }
}
