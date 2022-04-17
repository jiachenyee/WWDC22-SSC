//
//  SwiftUIView.swift
//  
//
//  Created by Jia Chen Yee on 12/4/22.
//

import SwiftUI

struct ReusableView: View {
    
    var code: Code
    
    var body: some View {
        switch code.codeBlock.name {
        case "Text": ReusableTextView(properties: TextProperties(code: code))
        case "Image": ReusableImageView(properties: ImageProperties(code: code))
        case "VStack": ReusableVStackView(properties: VStackProperties(code: code))
        case "HStack": ReusableHStackView(properties: HStackProperties(code: code))
        case "ZStack": ReusableZStackView(properties: ZStackProperties(code: code))
        case "Color": ReusableColorView(properties: ColorProperties(code: code))
        default: EmptyView()
        }
    }
}

struct ReusableView_Previews: PreviewProvider {
    static var previews: some View {
        ReusableView(code: .init(codeBlock: .hstack))
    }
}
