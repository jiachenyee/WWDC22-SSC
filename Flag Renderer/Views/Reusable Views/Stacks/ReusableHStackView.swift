//
//  ReusableHStackView.swift
//  
//
//  Created by Jia Chen Yee on 12/4/22.
//

import SwiftUI

struct ReusableHStackView: View {
    
    var properties: HStackProperties
    
    var body: some View {
        HStack(alignment: properties.alignment, spacing: properties.spacing) {
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

struct ReusableHStackView_Previews: PreviewProvider {
    static var previews: some View {
        ReusableHStackView(properties: .init())
    }
}
