//
//  InspectorParameterView.swift
//  
//
//  Created by Jia Chen Yee on 10/4/22.
//

import SwiftUI

struct InspectorParameterView: View {
    
    var parameter: CodeBlock.Parameter
    @Binding var parameters: [CodeBlock.ParameterValue]
    
    var isModifier = false
    
    var body: some View {
        HStack {
            
            if !parameter.humanReadableName.isEmpty {
                Text(parameter.humanReadableName)
                    .frame(width: 120, alignment: .leading)
            }
            
            switch parameter.dataType {
            case .options(let values):
                Spacer()
                
                let selection = Binding {
                    parameters.first(where: { $0.parameter.name == parameter.name })?.value as? String ?? "No value"
                } set: { newValue in
                    if let parameterIndex = parameters.firstIndex(where: { $0.parameter.humanReadableName == parameter.humanReadableName }) {
                        parameters[parameterIndex].value = newValue
                    } else {
                        var parameterValues = parameters
                        parameterValues.append(.init(parameter: parameter, value: newValue))
                        parameters = parameterValues.sorted(by: {
                            $0.parameter.order < $1.parameter.order
                        })
                    }
                }
                
                Picker("", selection: selection) {
                    ForEach(values, id: \.self) { value in
                        Text(value)
                    }
                }
                .pickerStyle(.menu)
            case .double:
                let text: Binding<Double> = Binding {
                    if let doubleValue = parameters.first(where: { $0.parameter.humanReadableName == parameter.humanReadableName })?.value as? Double {
                        return doubleValue
                    } else {
                        return 0
                    }
                } set: { newValue in
                    if let parameterIndex = parameters.firstIndex(where: { $0.parameter.humanReadableName == parameter.humanReadableName }) {
                        parameters[parameterIndex].value = newValue
                    } else {
                        var parameterValues = parameters
                        parameterValues.append(.init(parameter: parameter, value: newValue))
                        parameters = parameterValues.sorted(by: {
                            $0.parameter.order < $1.parameter.order
                        })
                    }
                }
                
                TextField("No value", value: text, format: .number)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            case .color:
                let color: Binding<Color> = Binding {
                    if let color = parameters.first(where: { $0.parameter.humanReadableName == parameter.humanReadableName })?.value as? UIColor {
                        return Color(uiColor: color)
                    } else {
                        return .clear
                    }
                } set: { newValue in
                    if let parameterIndex = parameters.firstIndex(where: { $0.parameter.humanReadableName == parameter.humanReadableName }) {
                        parameters[parameterIndex].value = UIColor(cgColor: newValue.cgColor!)
                    } else {
                        var parameterValues = parameters
                        parameterValues.append(.init(parameter: parameter, value: UIColor(cgColor: newValue.cgColor!)))
                        parameters = parameterValues.sorted(by: {
                            $0.parameter.order < $1.parameter.order
                        })
                    }
                }
                
                ColorPicker(selection: color, supportsOpacity: true) {}
            case .angle:
                let angle: Binding<Angle> = Binding {
                    if let angle = parameters.first(where: { $0.parameter.humanReadableName == parameter.humanReadableName })?.value as? Angle {
                        return angle
                    } else {
                        return .zero
                    }
                } set: { newValue in
                    if let parameterIndex = parameters.firstIndex(where: { $0.parameter.humanReadableName == parameter.humanReadableName }) {
                        parameters[parameterIndex].value = newValue
                    } else {
                        var parameterValues = parameters
                        parameterValues.append(.init(parameter: parameter, value: newValue))
                        parameters = parameterValues.sorted(by: {
                            $0.parameter.order < $1.parameter.order
                        })
                    }
                }
                
                AngleView(rotation: angle)
                    .frame(width: 256, height: 256)
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity, alignment: .center)
                
            case .string:
                let text: Binding<String> = Binding {
                    if let stringValue = parameters.first(where: { $0.parameter.humanReadableName == parameter.humanReadableName })?.value as? String {
                        return stringValue
                    } else {
                        return ""
                    }
                } set: { newValue in
                    if let parameterIndex = parameters.firstIndex(where: { $0.parameter.humanReadableName == parameter.humanReadableName }) {
                        parameters[parameterIndex].value = newValue
                    } else {
                        var parameterValues = parameters
                        parameterValues.append(.init(parameter: parameter, value: newValue))
                        parameters = parameterValues.sorted(by: {
                            $0.parameter.order < $1.parameter.order
                        })
                    }
                }
                
                TextField("No value", text: text)
            case .sfSymbol:
                let text: Binding<String> = Binding {
                    if let stringValue = parameters.first(where: { $0.parameter.humanReadableName == parameter.humanReadableName })?.value as? String {
                        return stringValue
                    } else {
                        return ""
                    }
                } set: { newValue in
                    if let parameterIndex = parameters.firstIndex(where: { $0.parameter.humanReadableName == parameter.humanReadableName }) {
                        parameters[parameterIndex].value = newValue
                    } else {
                        var parameterValues = parameters
                        parameterValues.append(.init(parameter: parameter, value: newValue))
                        parameters = parameterValues.sorted(by: {
                            $0.parameter.order < $1.parameter.order
                        })
                    }
                }
                
                NavigationLink {
                    SFSymbolView(selectedSymbol: text)
                } label: {
                    Rectangle()
                        .fill(.clear)
                    Image(systemName: text.wrappedValue)
                }
            default:
                TextField(parameter.dataType.defaultValue().swiftCode!, text: .constant(""))
            }
        }
    }
}
