import SwiftUI

struct CodeView: View {
    
    @Binding var selectedCode: Code?
    @Binding var code: Code
    @ObservedObject var codingViewModel: CodingViewModel
    
    var body: some View {
        let useTrailingClosureSyntax = (code.parameters.first?.parameter.dataType ?? .string) == .code
        let hasClosure = code.closure != nil
        
        VStack(alignment: .leading, spacing: 0) {
            Group {
                if hasClosure {
                    Button {
                        selectedCode = code
                        
                        // No clue why im assigning it again but it seems to work better this way
                        selectedCode = code
                    } label: {
                        HStack(alignment: .top, spacing: 0) {
                            Text(code.codeBlock.name)
                                .background(Color(code.codeBlock.color.withAlphaComponent(0.1)))
                            
                            Text(useTrailingClosureSyntax ? " {" : "(")
                                .background(Color(code.codeBlock.color.withAlphaComponent(0.1)))
                            
                            ForEach(code.parameters) { parameter in
                                if let name = parameter.parameter.name {
                                    Text(name + ": ")
                                        .padding(.leading, -6)
                                        .background(Color(code.codeBlock.color.withAlphaComponent(0.1)))
                                }
                                
                                if let swiftCode = parameter.value.swiftCode {
                                    switch parameter.parameter.dataType {
                                    case .options(_):
                                        Text(".\(parameter.value as! String)")
                                            .background(Color(code.codeBlock.color.withAlphaComponent(0.2)))
                                    default:
                                        Text(swiftCode)
                                            .background(Color(code.codeBlock.color.withAlphaComponent(0.2)))
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                                
                                if let parameterIndex = code.parameters.firstIndex(where: { $0.id == parameter.id }) {
                                    if parameterIndex < code.parameters.count - (hasClosure ? 2 : 1) {
                                        Text(", ")
                                            .background(Color(code.codeBlock.color.withAlphaComponent(0.1)))
                                    }
                                }
                            }
                            
                            if !useTrailingClosureSyntax {
                                Text(")")
                                    .background(Color(code.codeBlock.color.withAlphaComponent(0.1)))
                            }
                            
                            if hasClosure && !useTrailingClosureSyntax {
                                Text(" {")
                                    .background(Color(code.codeBlock.color.withAlphaComponent(0.1)))
                            }
                            Spacer()
                        }
                    }
                    .onDrag {
                        code.itemProvider
                    }
                    .onDrop(of: [.swiftSource], delegate: CodeDropDelegate(codingViewModel: codingViewModel,
                                                                           currentCode: code))
                } else {
                    Button {
                        selectedCode = code
                        
                        // No clue why im assigning it again but it seems to work better this way
                        selectedCode = code
                    } label: {
                        HStack(alignment: .top, spacing: 0) {
                            Text(code.codeBlock.name)
                                .background(Color(code.codeBlock.color.withAlphaComponent(0.1)))
                            
                            Text(useTrailingClosureSyntax ? " {" : "(")
                                .background(Color(code.codeBlock.color.withAlphaComponent(0.1)))
                            
                            ForEach(code.parameters) { parameter in
                                if let name = parameter.parameter.name {
                                    Text(name + ": ")
                                        .padding(.leading, -6)
                                        .background(Color(code.codeBlock.color.withAlphaComponent(0.1)))
                                }
                                
                                if let swiftCode = parameter.value.swiftCode {
                                    switch parameter.parameter.dataType {
                                    case .options(_):
                                        Text(".\(parameter.value as! String)")
                                            .background(Color(code.codeBlock.color.withAlphaComponent(0.2)))
                                    default:
                                        Text(swiftCode)
                                            .background(Color(code.codeBlock.color.withAlphaComponent(0.2)))
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                                
                                if let parameterIndex = code.parameters.firstIndex(where: { $0.id == parameter.id }) {
                                    if parameterIndex < code.parameters.count - (hasClosure ? 2 : 1) {
                                        Text(", ")
                                            .background(Color(code.codeBlock.color.withAlphaComponent(0.1)))
                                    }
                                }
                            }
                            
                            if !useTrailingClosureSyntax {
                                Text(")")
                                    .background(Color(code.codeBlock.color.withAlphaComponent(0.1)))
                            }
                            
                            if hasClosure && !useTrailingClosureSyntax {
                                Text(" {")
                                    .background(Color(code.codeBlock.color.withAlphaComponent(0.1)))
                            }
                            Spacer()
                        }
                    }
                    .onDrag {
                        code.itemProvider
                    }
                }
            }
            
            if let codeValue = code.closure {
                let embeddedCode = Binding {
                    codeValue
                } set: { newValue in
                    code.closure = newValue
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(embeddedCode) { $embeddedLine in
                        if embeddedLine.closure == nil {
                            
                            CodeView(selectedCode: $selectedCode,
                                     code: $embeddedLine, codingViewModel: codingViewModel)
                            .onDrop(of: [.swiftSource], delegate: CodeDropDelegate(codingViewModel: codingViewModel,
                                                                                   currentCode: code,
                                                                                   index: embeddedCode.firstIndex(where: {$0.id == embeddedLine.id})))
                        } else {
                            CodeView(selectedCode: $selectedCode,
                                     code: $embeddedLine, codingViewModel: codingViewModel)
                        }
                    }
                }
                .padding([.leading], 32)
                .padding([.vertical], 16)
                
                Text("}")
                    .background(Color(code.codeBlock.color.withAlphaComponent(0.1)))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                ForEach(code.modifiers, id: \.name) { modifier in
                    HStack(alignment: .top, spacing: 0) {
                        Text(".\(modifier.name)(")
                            .background(Color(code.codeBlock.color.withAlphaComponent(0.1)))
                        
                        ForEach(modifier.parameters) { parameter in
                            if let name = parameter.parameter.name {
                                Text(name + ": ")
                                    .padding(.leading, -6)
                                    .background(Color(code.codeBlock.color.withAlphaComponent(0.1)))
                            }
                            
                            if let swiftCode = parameter.value.swiftCode {
                                switch parameter.parameter.dataType {
                                case .options(_):
                                    Text(".\(parameter.value as! String)")
                                        .background(Color(code.codeBlock.color.withAlphaComponent(0.2)))
                                default:
                                    Text(swiftCode)
                                        .background(Color(code.codeBlock.color.withAlphaComponent(0.2)))
                                        .multilineTextAlignment(.leading)
                                }
                            }
                            
                            if let parameterIndex = modifier.parameters.firstIndex(where: { $0.id == parameter.id }) {
                                if parameterIndex < modifier.parameters.count - (hasClosure ? 2 : 1) {
                                    Text(", ")
                                        .background(Color(code.codeBlock.color.withAlphaComponent(0.1)))
                                }
                            }
                        }
                        
                        Text(modifier.suffix)
                            .background(Color(code.codeBlock.color.withAlphaComponent(0.1)))
                        Text(")")
                            .background(Color(code.codeBlock.color.withAlphaComponent(0.1)))
                    }
                }
                .padding(.top, 16)
            }
            .padding(.leading, hasClosure ? 0 : 32)
        }
        .foregroundColor(Color(code.codeBlock.color))
        .border(Color(code.codeBlock.color), width: selectedCode?.id == code.id ? 1 : 0)
        .font(.system(size: 16, weight: .regular, design: .monospaced))
        .background(selectedCode?.id == code.id ? Color(code.codeBlock.color).opacity(0.1) : Color.clear)
        .scaleEffect(
            codingViewModel.draggedInto?.id == code.id ? 1.1 : 1
        )
    }
}

struct CodeView_Previews: PreviewProvider {
    static var previews: some View {
        CodeView(selectedCode: .constant(nil), code: .constant(.init(codeBlock: .text)), codingViewModel: CodingViewModel())
    }
}
