//
//  CodeDropDelegate.swift
//  
//
//  Created by Jia Chen Yee on 10/4/22.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

class CodeDropDelegate: DropDelegate {
    
    var codingViewModel: CodingViewModel
    var currentCode: Code
    
    var index: Int?
    
    init(codingViewModel: CodingViewModel, currentCode: Code, index: Int? = nil) {
        self.codingViewModel = codingViewModel
        self.currentCode = currentCode
        
        self.index = index
    }
    
    func dropEntered(info: DropInfo) {
        withAnimation {
            codingViewModel.draggedInto = currentCode
        }
    }
    
    func dropExited(info: DropInfo) {
        withAnimation {
            if codingViewModel.draggedInto?.id == currentCode.id {
                codingViewModel.draggedInto = nil
            }
        }
    }
    
    func performDrop(info: DropInfo) -> Bool {
        guard let provider = info.itemProviders(for: [.swiftSource]).first,
              currentCode.parameters.contains(where: { value in
                  value.parameter.dataType == .code
              }) else { return false }
        
        withAnimation {
            codingViewModel.draggedInto = nil
        }
        
        provider.loadItem(forTypeIdentifier: UTType.swiftSource.identifier) { [self] newItem, error in
            
            guard let item = newItem as? Data,
                  let plist = try? PropertyListSerialization.propertyList(from: item,
                                                                          options: [],
                                                                          format: nil) as? NSDictionary,
                  let objects = plist.value(forKey: "$objects") as? [String],
                  let uuid = objects.filter({ $0.contains("-") }).first,
                  let droppedCode = codingViewModel.allCode.first(where: { $0.id == uuid })
            else { return }
            
            DispatchQueue.main.async { [self] in
                
                guard !codingViewModel.code.contains(where: { $0.id == uuid }),
                      !(codingViewModel.getHierarchy(with: currentCode) + [currentCode]).contains(where: { $0.id == droppedCode.id }) else { return }
                
                let hierarchy = codingViewModel.getHierarchy(with: droppedCode)
                
                var newCode = currentCode
                
                for code in hierarchy {
                    var mutableCode = code
                    if let closureValue = code.closure {
                        mutableCode.closure = closureValue
                            .filter {
                                $0.id != uuid
                            }
                            .map {
                                if $0.id == newCode.id {
                                    return newCode
                                } else {
                                    return $0
                                }
                            }
                    }
                    
                    newCode = mutableCode
                }
                if let index = codingViewModel.code.firstIndex(where: {
                    $0.id == newCode.id
                }) {
                    codingViewModel.code[index] = newCode
                }
                
                if let currentCodeIndex = codingViewModel.allCode.firstIndex(where: { $0.id == currentCode.id }),
                   let codeParameterIndex = codingViewModel.allCode[currentCodeIndex].parameters.firstIndex(where: { $0.parameter.dataType == .code }),
                   let previousValue = codingViewModel.allCode[currentCodeIndex].parameters[codeParameterIndex].value as? [Code] {
                    
                    let hierarchy = codingViewModel.getHierarchy(with: currentCode)
                    
                    var newCode = codingViewModel.allCode[currentCodeIndex]
                    
                    newCode.closure = previousValue
                    
                    if let index = index {
                        
                        if info.location.y > 5 {
                            if index + 1 > (newCode.closure?.count ?? 0) - 1 {
                                newCode.closure?.insert(droppedCode, at: index + 1)
                            } else {
                                newCode.closure?.append(droppedCode)
                            }
                        } else {
                            newCode.closure?.insert(droppedCode, at: index)
                        }
                        
                    } else {
                        newCode.closure?.append(droppedCode)
                    }
                    
                    for code in hierarchy {
                        var mutableCode = code
                        if let closureValue = code.closure {
                            mutableCode.closure = closureValue
                                .map {
                                    if $0.id == newCode.id {
                                        return newCode
                                    } else {
                                        return $0
                                    }
                                }
                        }
                        
                        newCode = mutableCode
                    }
                    
                    if let index = codingViewModel.code.firstIndex(where: {
                        $0.id == newCode.id
                    }) {
                        codingViewModel.code[index] = newCode
                    }
                    
                    codingViewModel.selectedCode = droppedCode
                }
            }
        }
        
        return true
    }
}
