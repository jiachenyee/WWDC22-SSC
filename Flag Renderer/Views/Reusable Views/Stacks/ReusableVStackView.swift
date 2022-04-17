//
//  ReusableVStackView.swift
//  
//
//  Created by Jia Chen Yee on 12/4/22.
//

import SwiftUI

struct ReusableVStackView: View {
    
    var properties: VStackProperties
    
    var body: some View {
        VStack(alignment: properties.alignment, spacing: properties.spacing) {
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

struct ReusableVStackView_Previews: PreviewProvider {
    static var previews: some View {
        ReusableVStackView(properties: .init())
    }
}
