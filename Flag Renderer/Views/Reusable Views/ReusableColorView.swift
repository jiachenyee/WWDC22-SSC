//
//  SwiftUIView.swift
//  
//
//  Created by Jia Chen Yee on 12/4/22.
//

import SwiftUI

struct ReusableColorView: View {
    
    var properties: ColorProperties
    
    var body: some View {
        Color(red: properties.red,
              green: properties.green,
              blue: properties.blue,
              opacity: properties.opacity)
            .padding(properties.paddingEdges, properties.paddingLength)
            .background(Color(uiColor: properties.backgroundColor))
            .cornerRadius(properties.cornerRadius)
            .rotationEffect(properties.rotation)
    }
}

struct ReusableColorView_Previews: PreviewProvider {
    static var previews: some View {
        ReusableColorView(properties: .init())
    }
}
