//
//  File.swift
//  
//
//  Created by Jia Chen Yee on 6/4/22.
//

import Foundation
import UniformTypeIdentifiers

struct Code: Identifiable {
    var codeBlock: CodeBlock
    var parameters: [CodeBlock.ParameterValue] = []
    var modifiers: [CodeBlock.ModifierValue] = []
    
    var id: String
    
    var closure: [Code]? {
        get {
            if let embeddedCodeBlock = parameters.firstIndex(where: { $0.parameter.dataType == .code }),
               let codeValue = parameters[embeddedCodeBlock].value as? [Code] {
                return codeValue
            } else {
                return nil
            }
        }
        set {
            if let newValue = newValue,
               let embeddedCodeBlock = parameters.firstIndex(where: { $0.parameter.dataType == .code }) {
                parameters[embeddedCodeBlock].value = newValue
            }
        }
    }
    
    var itemProvider: NSItemProvider {
        let item = NSItemProvider(
            item: id as NSString,
            typeIdentifier: UTType.swiftSource.identifier)
        
        return item
    }
    
    init(codeBlock: CodeBlock) {
        self.codeBlock = codeBlock
        parameters = codeBlock.parameters.filter {
            !$0.optional
        }.map { parameter in
            CodeBlock.ParameterValue(parameter: parameter, value: parameter.dataType.defaultValue())
        }
        
        id = "\(codeBlock.name)-\(Date.now.timeIntervalSince1970)"
    }
    
    init(codeBlock: CodeBlock, closure: Code...) {
        self.codeBlock = codeBlock
        parameters = codeBlock.parameters.filter {
            !$0.optional
        }.map { parameter in
            CodeBlock.ParameterValue(parameter: parameter, value: parameter.dataType.defaultValue())
        }
        
        self.id = "\(codeBlock.name)-\(Date.now.timeIntervalSince1970)"
        self.closure = closure
        
    }
}
