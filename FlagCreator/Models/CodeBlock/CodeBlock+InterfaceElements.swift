//
//  File.swift
//  
//
//  Created by Jia Chen Yee on 10/4/22.
//

import SwiftUI
import Foundation

extension CodeBlock {
    static let text = CodeBlock(name: "Text",
                                parameters: [.init(humanReadableName: "Text",
                                                   dataType: .string,
                                                   optional: false,
                                                   order: 0)],
                                modifiers: [[
                                    Modifier(name: "font",
                                             humanReadableName: "Font",
                                             systemName: "textformat.abc",
                                             parameters: [
                                                Parameter(name: ".system(size",
                                                          humanReadableName: "Size",
                                                          dataType: .double,
                                                          optional: false,
                                                          order: 0),
                                                Parameter(name: "weight",
                                                          humanReadableName: "Weight",
                                                          dataType: .options(values: ["regular",
                                                                                      "bold",
                                                                                      "heavy",
                                                                                      "light",
                                                                                      "medium",
                                                                                      "semibold",
                                                                                      "thin",
                                                                                      "ultraLight",
                                                                                      "black"]),
                                                          optional: false,
                                                          order: 1),
                                                Parameter(name: "design",
                                                          humanReadableName: "Design",
                                                          dataType: .options(values: ["default", "monospaced", "rounded", "serif"]),
                                                          optional: false,
                                                          order: 2)
                                             ],
                                             order: 0, suffix: ")"),
                                    Modifier(name: "multilineTextAlignment",
                                             humanReadableName: "Text Alignment",
                                             systemName: "text.alignleft",
                                             parameters: [
                                                Parameter(humanReadableName: "Direction", dataType: .options(values: ["leading", "trailing", "center"]),
                                                          optional: false, order: 0)
                                             ],
                                             order: 1),
                                    Modifier(name: "foregroundColor",
                                             humanReadableName: "Foreground Color",
                                             systemName: "smallcircle.filled.circle",
                                             parameters: [
                                                Parameter(humanReadableName: "Color", dataType: .color,
                                                          optional: false, order: 0)
                                             ],
                                             order: 2)
                                ], Modifier.viewModifiers], color: .systemBlue)
    
    static let image = CodeBlock(name: "Image",
                                 parameters: [.init(name: "systemName",
                                                    humanReadableName: "Symbol",
                                                    dataType: .sfSymbol,
                                                    optional: false,
                                                    order: 0)],
                                 modifiers: [
                                    [
                                        Modifier(name: "symbolRenderingMode",
                                                 humanReadableName: "Rendering Mode", systemName: "paintbrush.pointed", parameters: [Parameter(humanReadableName: "Mode", dataType: .options(values: ["monochrome", "multicolor", "hierarchical", "palette"]), optional: false, order: 0)],
                                                 order: 0),
                                        Modifier(name: "imageScale",
                                                 humanReadableName: "Image Scale", systemName: "arrow.up.left.and.down.right.and.arrow.up.right.and.down.left", parameters: [Parameter(humanReadableName: "Scale", dataType: .options(values: ["small", "medium", "large"]), optional: false, order: 0)],
                                                 order: 1),
                                        Modifier(name: "font",
                                                 humanReadableName: "Font",
                                                 systemName: "textformat.abc",
                                                 parameters: [
                                                    Parameter(name: ".system(size",
                                                              humanReadableName: "Size",
                                                              dataType: .double,
                                                              optional: false,
                                                              order: 0),
                                                    Parameter(name: "weight",
                                                              humanReadableName: "Weight",
                                                              dataType: .options(values: ["regular",
                                                                                          "bold",
                                                                                          "heavy",
                                                                                          "light",
                                                                                          "medium",
                                                                                          "semibold",
                                                                                          "thin",
                                                                                          "ultraLight",
                                                                                          "black"]),
                                                              optional: false,
                                                              order: 1),
                                                    Parameter(name: "design",
                                                              humanReadableName: "Design",
                                                              dataType: .options(values: ["default", "monospaced", "rounded", "serif"]),
                                                              optional: false,
                                                              order: 2)
                                                 ],
                                                 order: 2, suffix: ")"),
                                        Modifier(name: "foregroundColor",
                                                 humanReadableName: "Foreground Color",
                                                 systemName: "smallcircle.filled.circle",
                                                 parameters: [
                                                    Parameter(humanReadableName: "Color", dataType: .color,
                                                              optional: false, order: 0)
                                                 ],
                                                 order: 3)
                                    ],
                                    Modifier.viewModifiers], color: .systemGreen)
    
    static let hstack = CodeBlock(name: "HStack",
                                  parameters: [
                                    .init(name: "alignment",
                                          humanReadableName: "Alignment",
                                          dataType: .options(values: ["top", "center", "bottom", "firstTextBaseline", "lastTextBaseline"]),
                                          optional: true,
                                          order: 0),
                                    .init(name: "spacing",
                                          humanReadableName: "Spacing",
                                          dataType: .double,
                                          optional: true,
                                          order: 1),
                                    .init(humanReadableName: "Content",
                                          dataType: .code,
                                          optional: false,
                                          order: 2)
                                  ],
                                  modifiers: [Modifier.viewModifiers], color: .systemRed)
    
    static let vstack = CodeBlock(name: "VStack",
                                  parameters: [
                                    .init(name: "alignment",
                                          humanReadableName: "Alignment",
                                          dataType: .options(values: ["leading", "center", "trailing"]),
                                          optional: true, order: 0),
                                    .init(name: "spacing",
                                          humanReadableName: "Spacing",
                                          dataType: .double,
                                          optional: true, order: 1),
                                    .init(humanReadableName: "Content",
                                          dataType: .code,
                                          optional: false, order: 2)
                                  ],
                                  modifiers: [Modifier.viewModifiers], color: .systemOrange)
    
    static let zstack = CodeBlock(name: "ZStack",
                                  parameters: [.init(name: "alignment",
                                                     humanReadableName: "Alignment",
                                                     dataType: .options(values: ["center", "topLeading", "top", "topTrailing", "leading", "trailing", "bottomLeading", "bottom", "bottomTrailing"]),
                                                     optional: true, order: 0),
                                               .init(humanReadableName: "Content",
                                                     dataType: .code,
                                                     optional: false, order: 1)],
                                  modifiers: [Modifier.viewModifiers], color: .systemIndigo)
    
    static let color = CodeBlock(name: "Color",
                                 parameters: [
                                    .init(name: "red",
                                          humanReadableName: "Red",
                                          dataType: .double,
                                          optional: false,
                                          order: 0),
                                    .init(name: "green",
                                          humanReadableName: "Green",
                                          dataType: .double,
                                          optional: false,
                                          order: 1),
                                    .init(name: "blue",
                                          humanReadableName: "Blue",
                                          dataType: .double,
                                          optional: false,
                                          order: 2),
                                    .init(name: "opacity",
                                          humanReadableName: "Opacity",
                                          dataType: .double,
                                          optional: false,
                                          order: 3)],
                                 modifiers: [Modifier.viewModifiers], color: .systemBrown)
}
