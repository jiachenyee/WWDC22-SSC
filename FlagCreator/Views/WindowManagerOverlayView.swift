//
//  SwiftUIView.swift
//  
//
//  Created by Jia Chen Yee on 12/4/22.
//

import SwiftUI

struct WindowManagerOverlayView: View {
    
    var separatorTranslation: CGSize
    
    var body: some View {
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
                .edgesIgnoringSafeArea(.all)
            
            GeometryReader { reader in
                HStack(alignment: .center, spacing: 0) {
                    let firstSectionWidth = reader.size.width / 2 + separatorTranslation.width
                    let secondSectionWidth = reader.size.width / 2 - separatorTranslation.width
                    
                    VStack {
                        Image(systemName: "curlybraces")
                            .font(.system(size: 32))
                            .padding()
                            .foregroundColor(.accentColor)
                        Text("Editor")
                    }
                    .frame(width: firstSectionWidth)
                    .opacity(firstSectionWidth < 200 ? 0 : firstSectionWidth < 300 ? Double(Int(firstSectionWidth) % 200) / 300 : 1)
                    
                    VStack {
                        Image(systemName: "flag")
                            .font(.system(size: 32))
                            .padding()
                            .foregroundColor(.accentColor)
                        Text("Flag Preview")
                    }
                    .frame(width: secondSectionWidth)
                    .opacity(secondSectionWidth < 200 ? 0 : secondSectionWidth < 300 ? Double(Int(secondSectionWidth) % 200) / 300 : 1)
                }
                .frame(maxHeight: .infinity, alignment: .center)
            }
        }
    }
}

struct WindowManagerOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        WindowManagerOverlayView(separatorTranslation: .zero)
    }
}
