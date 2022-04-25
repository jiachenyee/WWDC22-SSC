import Foundation
import UIKit
import SwiftUI

extension CodeBlock {
    struct Parameter {
        
        var name: String?
        var humanReadableName: String
        var dataType: DataType
        var optional: Bool
        
        var order: Int
        
        enum DataType: Equatable, Hashable {
            case int
            case double
            case string
            case boolean
            case code
            case options(values: [String])
            case sfSymbol
            
            case angle
            case color
            
            func defaultValue() -> ParameterDataValue {
                switch self {
                case .int:
                    return 0
                case .double:
                    return 0.0
                case .string:
                    return "Hello, world!"
                case .boolean:
                    return true
                case .code:
                    return [CodeBlock]()
                case .options(values: let values):
                    return values.first!
                case .color:
                    return UIColor.red
                case .angle:
                    return Angle.zero
                case .sfSymbol:
                    return "globe"
                }
            }
        }
    }
}

protocol ParameterDataValue {
    var swiftCode: String? { get }
}

extension Array: ParameterDataValue {
    var swiftCode: String? {
        nil
    }
}

extension Int: ParameterDataValue {
    var swiftCode: String? {
        String(self)
    }
}

extension Double: ParameterDataValue {
    var swiftCode: String? {
        String(self)
    }
}

extension Bool: ParameterDataValue {
    var swiftCode: String? {
        self.description
    }
}

extension String: ParameterDataValue {
    var swiftCode: String? {
        "\"" + self.description + "\""
    }
}

extension Angle: ParameterDataValue {
    var swiftCode: String? {
        ".degrees(\(String(format: "%.2f", degrees)))"
    }
}

extension UIColor: ParameterDataValue {
    var swiftCode: String? {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return "Color(red: \(red), green: \(green), blue: \(blue), opacity: \(alpha))"
    }
}
