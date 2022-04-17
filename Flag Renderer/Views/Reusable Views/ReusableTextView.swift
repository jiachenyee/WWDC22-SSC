//
//  ReusableTextView.swift
//  
//
//  Created by Jia Chen Yee on 10/4/22.
//

import SwiftUI

struct ReusableTextView: View {
    
    var properties: TextProperties
    
    var body: some View {
        Text(properties.text)
            .font(.system(size: properties.fontSize, weight: properties.fontWeight, design: properties.fontDesign))
            .multilineTextAlignment(properties.textAlignment)
            .foregroundColor(Color(uiColor: properties.foregroundColor))
            .padding(properties.paddingEdges, properties.paddingLength)
            .background(Color(uiColor: properties.backgroundColor))
            .cornerRadius(properties.cornerRadius)
            .rotationEffect(properties.rotation)
    }
}

struct ReusableTextView_Previews: PreviewProvider {
    static var previews: some View {
        ReusableTextView(properties: .init())
    }
}
