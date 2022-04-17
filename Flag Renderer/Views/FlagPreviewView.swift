//
//  FlagPreviewView.swift
//  
//
//  Created by Jia Chen Yee on 12/4/22.
//

import SwiftUI

struct FlagPreviewView: View {
    
    @Binding var stage: Stage
    var namespace: Namespace.ID
    
    var code: [Code]
    
    var flagWidth: CGFloat
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .frame(maxWidth: .infinity)
                .edgesIgnoringSafeArea(.vertical)
            VStack {
                Text("Flag Preview")
                    .font(.headline)
                
                Spacer()
                
                FlagView(namespace: namespace, code: code, flagWidth: flagWidth)
                
                Spacer()
                Button {
                    withAnimation {
                        stage = .flagPreview
                    }
                } label: {
                    Label("Continue", systemImage: "play.fill")
                        .padding()
                        .padding(.horizontal)
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(.infinity)
                }
            }
            .padding()
        }
    }
}
