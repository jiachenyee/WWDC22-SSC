//
//  SwiftUIView.swift
//  
//
//  Created by Jia Chen Yee on 10/4/22.
//

import SwiftUI

struct InspectorOptionsView: View {
    
    @Binding var selectedCode: Code
    @Binding var parent: Code?
    
    @State private var warningAlertPresented = false
    
    var body: some View {
        List {
            Section("Order") {
                Button {
                    if let index = parent?.closure?.firstIndex(where: { selectedCode.id == $0.id }) {
                        withAnimation {
                            parent?.closure?.insert(selectedCode, at: index - 1)
                            parent?.closure?.remove(at: index + 1)
                        }
                    }
                } label: {
                    Label("Move Up", systemImage: "text.insert")
                }
                .disabled(parent == nil || parent?.closure?.first?.id == selectedCode.id)
                
                Button {
                    if let index = parent?.closure?.firstIndex(where: { selectedCode.id == $0.id }) {
                        withAnimation {
                            parent?.closure?.insert(selectedCode, at: index + 2)
                            parent?.closure?.remove(at: index)
                        }
                    }
                } label: {
                    Label("Move Down", systemImage: "text.append")
                }
                .disabled(parent == nil || parent?.closure?.last?.id == selectedCode.id)
            }
            
            Section("Parameters") {
                if selectedCode.codeBlock.name == "Color" {
                    let placeholderParameter = CodeBlock.Parameter(humanReadableName: "Color", dataType: .color, optional: false, order: 0)
                    let bindingParameters: Binding<[CodeBlock.ParameterValue]> = Binding {
                        
                        if let redValue = selectedCode.parameters.first(where: { $0.parameter.name == "red" })?.value as? Double,
                           let greenValue = selectedCode.parameters.first(where: { $0.parameter.name == "green" })?.value as? Double,
                           let blueValue = selectedCode.parameters.first(where: { $0.parameter.name == "blue" })?.value as? Double,
                           let alphaValue = selectedCode.parameters.first(where: { $0.parameter.name == "opacity" })?.value as? Double {
                            
                            return [.init(parameter: placeholderParameter, value: UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: alphaValue))]
                        } else {
                            return []
                        }
                        
                    } set: { newValue in
                        if let parameterValue = newValue.first?.value as? UIColor {
                            var red: CGFloat = 0.0
                            var green: CGFloat = 0.0
                            var blue: CGFloat = 0.0
                            var alpha: CGFloat = 0.0
                            
                            parameterValue.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                            
                            selectedCode.parameters = selectedCode.parameters.map { value in
                                var mutableValue = value
                                switch value.parameter.name {
                                case "red": mutableValue.value = Double(red)
                                case "green": mutableValue.value = Double(green)
                                case "blue": mutableValue.value = Double(blue)
                                default: mutableValue.value = Double(alpha)
                                }
                                
                                return mutableValue
                            }
                        }
                    }

                    
                    InspectorParameterView(parameter: placeholderParameter, parameters: bindingParameters)
                } else {
                    ForEach(selectedCode.codeBlock.parameters, id: \.name) { parameter in
                        if parameter.dataType != .code {
                            InspectorParameterView(parameter: parameter, parameters: $selectedCode.parameters)
                        }
                    }
                }
            }
            
            ForEach($selectedCode.modifiers, id: \.name) { $modifier in
                
                Section {
                    ForEach(modifier.parameters) { parameter in
                        InspectorParameterView(parameter: parameter.parameter, parameters: $modifier.parameters, isModifier: true)
                    }
                } header: {
                    HStack {
                        Text(modifier.humanReadableName)
                        Spacer()
                        Button {
                            guard let index = selectedCode.modifiers.firstIndex(where: { $0.name == modifier.name }) else { return }
                            
                            _ = withAnimation {
                                selectedCode.modifiers.remove(at: index)
                            }
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
            }
            
            if parent != nil {
                Button(role: .destructive) {
                    withAnimation {
                        if selectedCode.closure != nil {
                            warningAlertPresented = true
                        } else {
                            if let index = parent?.closure?.firstIndex(where: { $0.id == selectedCode.id }) {
                                parent?.closure?.remove(at: index)
                            }
                        }
                    }
                } label: {
                    Label("Delete Element", systemImage: "trash")
                        .foregroundColor(.red)
                }
                .alert(isPresented: $warningAlertPresented) {
                    Alert(title: Text("Delete \(selectedCode.codeBlock.name)?"),
                          message: Text("Deleting this element will delete all elements in it."), primaryButton: .destructive(Text("Delete")) {
                        if let index = parent?.closure?.firstIndex(where: { $0.id == selectedCode.id }) {
                            parent?.closure?.remove(at: index)
                        }
                    }, secondaryButton: .cancel())
                }
            }

        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    let modifiers = selectedCode.codeBlock.modifiers.enumerated().map {
                        (index: $0.offset, element: $0.element)
                    }
                    
                    ForEach(modifiers, id: \.index) { modifierSet in
                        ForEach(modifierSet.element, id: \.name) { modifier in
                            if !selectedCode.modifiers.contains(where: { $0.name == modifier.name })  {
                                Button {
                                    var code = selectedCode
                                    code.modifiers.append(.init(modifier: modifier))
                                    code.modifiers.sort(by: {
                                        $0.order < $1.order
                                    })
                                    
                                    withAnimation {
                                        selectedCode = code
                                    }
                                } label: {
                                    Label(modifier.humanReadableName, systemImage: modifier.systemName)
                                }
                            }
                        }
                        Divider()
                    }
                } label: {
                    Image(systemName: "paintbrush")
                }
                .disabled(selectedCode.codeBlock.modifiers
                    .flatMap { $0 }.count == selectedCode.modifiers.count)
            }
        }
    }
}

struct InspectorOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        InspectorOptionsView(selectedCode: .constant(.init(codeBlock: .hstack)),
                             parent: .constant(.init(codeBlock: .hstack)))
    }
}
