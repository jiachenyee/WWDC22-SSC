//
//  ViewProperties.swift
//  
//
//  Created by Jia Chen Yee on 10/4/22.
//

import Foundation
import SwiftUI

protocol ViewProperties {
    var paddingLength: Double { get set }
    var paddingEdges: Edge.Set { get set }
    
    var backgroundColor: UIColor { get set }
    
    var cornerRadius: Double { get set }
    var rotation: Angle { get set }
    
    
    init(code: Code)
    init()
}
