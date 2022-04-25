//
//  FlagRendererView.swift
//  
//
//  Created by Jia Chen Yee on 12/4/22.
//

import SwiftUI

struct FlagRendererView: View {
    
    var code: [Code]
    
    var body: some View {
        ForEach(code) { code in
            ReusableView(code: code)
        }
    }
}

struct FlagRendererView_Previews: PreviewProvider {
    static var previews: some View {
        FlagRendererView(code: [])
    }
}
