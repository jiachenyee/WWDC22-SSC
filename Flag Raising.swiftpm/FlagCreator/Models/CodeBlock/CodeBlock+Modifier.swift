//
//  CodeBlock+Modifier.swift
//  
//
//  Created by Jia Chen Yee on 12/4/22.
//

import Foundation
import UIKit

extension CodeBlock {
    struct ModifierValue {
        var name: String
        var humanReadableName: String
        var systemName: String
        var parameters: [ParameterValue] = []
        
        var suffix = ""
        
        var order: Int
        
        init(modifier: Modifier) {
            self.name = modifier.name
            self.humanReadableName = modifier.humanReadableName
            self.systemName = modifier.humanReadableName
            self.parameters = modifier.parameters.map {
                ParameterValue(parameter: $0, value: $0.dataType.defaultValue())
            }
            self.order = modifier.order
            self.suffix = modifier.suffix
        }
    }
    
    struct Modifier {
        var name: String
        var humanReadableName: String
        var systemName: String
        var parameters: [Parameter] = []
        var order: Int
        var suffix = ""
        
        static let viewModifiers = [
            Modifier(name: "padding",
                     humanReadableName: "Padding",
                     systemName: "rectangle.inset.filled",
                     parameters: [
                        Parameter(humanReadableName: "Edges",
                                  dataType: .options(values: ["leading", "trailing", "bottom", "top", "vertical", "horizontal", "all"]),
                                  optional: true,
                                  order: 0),
                        Parameter(humanReadableName: "Length",
                                  dataType: .double,
                                  optional: true,
                                  order: 1)
                     ],
                     order: 100),
            Modifier(name: "background",
                     humanReadableName: "Background",
                     systemName: "smallcircle.filled.circle.fill",
                     parameters: [Parameter(humanReadableName: "Color",
                                            dataType: .color,
                                            optional: false,
                                            order: 0)],
                     order: 101),
            Modifier(name: "cornerRadius",
                     humanReadableName: "Round Corners",
                     systemName: "rectangle.roundedtop.fill",
                     parameters: [Parameter(humanReadableName: "Radius",
                                            dataType: .double,
                                            optional: false,
                                            order: 0)],
                     order: 102),
            Modifier(name: "rotationEffect",
                     humanReadableName: "Rotation",
                     systemName: "rotate.left",
                     parameters: [
                        Parameter(humanReadableName: "",
                                  dataType: .angle,
                                  optional: false,
                                  order: 0)
                     ],
                     order: 103)
        ]
    }
}
