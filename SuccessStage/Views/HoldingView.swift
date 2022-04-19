//
//  View+Snapshot.swift
//  
//
//  Created by Jia Chen Yee on 19/4/22.
//

import Foundation
import SwiftUI

struct HoldingView<T: View>: UIViewRepresentable {
    
    var content: T
    
    @Binding var view: UIView
    
    func makeUIView(context: Context) -> UIView {
        let controller = UIHostingController(rootView: content)
        let view = controller.view
        
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false) { _ in
            self.view = view!
        }
        return view!
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
