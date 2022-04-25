//
//  TextProperties.swift
//  
//
//  Created by Jia Chen Yee on 10/4/22.
//

import Foundation
import SwiftUI

struct TextProperties: ViewProperties {
    
    var text: String = ""
    
    var fontSize: Double = 17
    var fontWeight: Font.Weight = .regular
    var fontDesign: Font.Design = .default
    
    var foregroundColor: UIColor = .label
    var backgroundColor: UIColor = .clear
    
    var cornerRadius: Double = .zero
    
    var paddingLength: Double = 0
    var paddingEdges: Edge.Set = .all
    
    var textAlignment: TextAlignment = .leading
    
    var rotation: Angle = .zero
    
    init(code: Code) {
        if let text = code.parameters.first?.value as? String { self.text = text }
        
        for modifier in code.modifiers {
            switch modifier.name {
            case "font":
                if let fontSize = modifier.parameters.first(where: {
                    $0.parameter.humanReadableName == "Size"
                })?.value as? Double,
                   let weight = modifier.parameters.first(where: {
                       $0.parameter.humanReadableName == "Weight"
                   })?.value as? String,
                   let design = modifier.parameters.first(where: {
                       $0.parameter.humanReadableName == "Design"
                   })?.value as? String {
                    
                    self.fontSize = fontSize
                    
                    switch weight {
                    case "regular": self.fontWeight = .regular
                    case "bold": self.fontWeight = .bold
                    case "heavy": self.fontWeight = .heavy
                    case "light": self.fontWeight = .light
                    case "medium": self.fontWeight = .medium
                    case "semibold": self.fontWeight = .semibold
                    case "thin": self.fontWeight = .thin
                    case "ultraLight": self.fontWeight = .ultraLight
                    case "black": self.fontWeight = .black
                    default: break
                    }
                    
                    switch design {
                    case "default": self.fontDesign = .default
                    case "monospaced": self.fontDesign = .monospaced
                    case "rounded": self.fontDesign = .rounded
                    case "serif": self.fontDesign = .serif
                    default: break
                    }
                }
            case "foregroundColor":
                if let foregroundColor = modifier.parameters.first?.value as? UIColor {
                    self.foregroundColor = foregroundColor
                }
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
            case "multilineTextAlignment":
                if let textAlignment = modifier.parameters.first?.value as? String {
                    switch textAlignment {
                    case "leading": self.textAlignment = .leading
                    case "trailing": self.textAlignment = .trailing
                    case "center": self.textAlignment = .center
                    default: self.textAlignment = .leading
                    }
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
