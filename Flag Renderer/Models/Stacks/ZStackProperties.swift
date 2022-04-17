//
//  ZStackProperties.swift
//  
//
//  Created by Jia Chen Yee on 12/4/22.
//

import Foundation
import SwiftUI

struct ZStackProperties: ViewProperties {
    
    var alignment: Alignment = .center
    
    var content: [Code] = []
    
    var paddingLength: Double = 0
    var paddingEdges: Edge.Set = .all
    
    var backgroundColor: UIColor = .clear
    
    var cornerRadius: Double = .zero
    var rotation: Angle = .zero
    
    init(code: Code) {
        for parameter in code.parameters {
            if parameter.parameter.name == "alignment",
               let value = parameter.value as? String {
                switch value {
                case "topLeading": alignment = .topLeading
                case "top": alignment = .top
                case "topTrailing": alignment = .topTrailing
                case "leading": alignment = .leading
                case "center": alignment = .center
                case "trailing": alignment = .trailing
                case "bottomLeading": alignment = .bottomLeading
                case "bottom": alignment = .bottom
                case "bottomTrailing": alignment = .bottomTrailing
                default: break
                }
            }
        }
        
        if let closure = code.closure {
            content = closure
        }
        
        for modifier in code.modifiers {
            switch modifier.name {
            case "background":
                if let backgroundColor = modifier.parameters.first?.value as? UIColor {
                    self.backgroundColor = backgroundColor
                }
            case "padding":
                if let edges = modifier.parameters.first(where: {
                    $0.parameter.humanReadableName == "Edges"
                })?.value as? String,
                   let length = modifier.parameters.first(where: {
                       $0.parameter.humanReadableName == "Length"
                   })?.value as? Double {
                    
                    switch edges {
                    case "all": paddingEdges = .all
                    case "horizontal": paddingEdges = .horizontal
                    case "vertical": paddingEdges = .vertical
                    case "top": paddingEdges = .top
                    case "bottom": paddingEdges = .bottom
                    case "trailing": paddingEdges = .trailing
                    case "leading": paddingEdges = .leading
                    default: break
                    }
                    
                    paddingLength = length
                }
            case "rotationEffect":
                if let rotation = modifier.parameters.first?.value as? Angle {
                    self.rotation = rotation
                }
            case "cornerRadius":
                if let cornerRadius = modifier.parameters.first?.value as? Double {
                    self.cornerRadius = cornerRadius
                }
            default: break
            }
        }
        
    }
    
    init() {}
}
