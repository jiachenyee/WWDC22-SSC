//
//  ReusableZStackView.swift
//  
//
//  Created by Jia Chen Yee on 12/4/22.
//

import SwiftUI

struct ReusableZStackView: View {
    
    var properties: ZStackProperties
    
    var body: some View {
        ZStack(alignment: properties.alignment) {
            ForEach(properties.content) { code in
                ReusableView(code: code)
            }
        }
        .padding(properties.paddingEdges, properties.paddingLength)
        .background(Color(uiColor: properties.backgroundColor))
        .cornerRadius(properties.cornerRadius)
        .rotationEffect(properties.rotation)
    }
}

struct ReusableZStackView_Previews: PreviewProvider {
    static var previews: some View {
        ReusableZStackView(properties: .init())
    }
}
