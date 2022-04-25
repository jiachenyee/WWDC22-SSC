import Foundation
import UIKit

struct CodeBlock: ParameterDataValue {
    var name: String
    var parameters: [Parameter]
    var modifiers: [[Modifier]]
    
    var color: UIColor
    
    var swiftCode: String? = nil
}

extension CodeBlock {
    struct ParameterValue: Identifiable {
        var parameter: Parameter
        var value: ParameterDataValue
        
        var id = UUID()
    }
}
