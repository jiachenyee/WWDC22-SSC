//
//  ReusableImageView.swift
//  
//
//  Created by Jia Chen Yee on 10/4/22.
//

import SwiftUI

struct ReusableImageView: View {
    
    var properties: ImageProperties
    
    var body: some View {
        Image(systemName: properties.systemName)
            .symbolRenderingMode(properties.symbolRenderingMode)
            .imageScale(properties.imageScale)
            .font(.system(size: properties.fontSize, weight: properties.fontWeight, design: properties.fontDesign))
            .foregroundColor(Color(uiColor: properties.foregroundColor))
            .padding(properties.paddingEdges, properties.paddingLength)
            .background(Color(uiColor: properties.backgroundColor))
            .cornerRadius(properties.cornerRadius)
            .rotationEffect(properties.rotation)
    }
}

struct ReusableImageView_Previews: PreviewProvider {
    static var previews: some View {
        ReusableImageView(properties: ImageProperties())
    }
}
