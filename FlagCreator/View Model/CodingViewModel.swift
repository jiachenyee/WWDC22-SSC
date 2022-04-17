import Foundation
import SwiftUI

class CodingViewModel: ObservableObject {
    @Published var code: [Code] = [
        Code(codeBlock: .vstack,
             closure:
                Code(codeBlock: .image),
                Code(codeBlock: .text),
                Code(codeBlock: .vstack,
                     closure:
                        Code(codeBlock: .image),
                     Code(codeBlock: .hstack,
                          closure:
                            Code(codeBlock: .image),
                          Code(codeBlock: .text)
                         )
                 )
            )
    ]
    
    @Published var draggedInto: Code?
    
    var allCode: [Code] {
        get {
            var allCode: [Code] = code
            
            allCode = searchClosure(closure: code)
            
            func searchClosure(closure: [Code]) -> [Code] {
                var returnedCode: [Code] = []
                for line in closure {
                    if let closure = line.closure {
                        returnedCode.append(contentsOf: searchClosure(closure: closure) + [line])
                    } else {
                        returnedCode.append(line)
                    }
                }
                
                return returnedCode
            }
            
            return allCode.removingDuplicates()
        }
    }
    
    func getHierarchy(with targetCode: Code) -> [Code] {
        var hierarchy: [Code] = []
        
        var activeTargetCode = targetCode
        
        while true {
            if let parent = parent(for: activeTargetCode) {
                hierarchy.append(parent)
                activeTargetCode = parent
            } else {
                break
            }
        }
        
        return hierarchy
    }
    
    func parent(for code: Code) -> Code? {
        return allCode.first {
            $0.closure?.contains(where: { codeValue in
                codeValue.id == code.id
            }) ?? false
        }
    }
    
    @Published var selectedCode: Code?
    
    init() {
        
    }
}

extension Array where Element: Identifiable {
    func removingDuplicates() -> Self {
        var result = [Element]()
        for value in self {
            if !result.contains(where: {
                value.id == $0.id
            }) {
                result.append(value)
            }
        }
         return result
    }
    
}
