//
//  ARView.swift
//  
//
//  Created by Jia Chen Yee on 20/4/22.
//

import Foundation
import ARKit
import SwiftUI

struct ARView: UIViewControllerRepresentable {
    
    var flagImage: UIImage
    
    func makeUIViewController(context: Context) -> ARViewController {
        let vc = ARViewController()
        
        vc.flagImage = flagImage
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: ARViewController, context: Context) {}
}
