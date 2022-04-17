//
//  FlagRaisingPreviewView.swift
//
//
//  Created by Jia Chen Yee on 12/4/22.
//

import Foundation
import SwiftUI

struct FlagRaisingPreviewView: View {
    
    @Binding var stage: Stage
    
    var namespace: Namespace.ID
    var code: [Code]
    var flagWidth: CGFloat
    
    @State var enterSplitScreen = false
    
    @State var variableDeclaration = ""
    @State var variableName = ""
    @State var raiseButtonAction = ""
    
    @State var issues: [String] = []
    
    @State var isIssuesPopoverPresented = false
    
    var body: some View {
        HStack(spacing: 0) {
            if enterSplitScreen {
                NavigationView {
                    ScrollView {
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading) {
                                Text("""
**Introducing `@State`**
`@State` is a *property wrapper* that allows SwiftUI to help you keep track of them.

When a @State variable is changed, it refreshes any view that uses it. This way, it ensures that the view's content is up to date.

To declare a @State variable, add `@State` before a normal variable declaration.
""")
                                Text("@State var flagOffset = 0.0")
                                    .font(.system(.body, design: .monospaced))
                                    .padding(4)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(4)
                                    .padding(.bottom)
                                
                                Text("""
**Introducing `.offset`**
The `.offset` modifier lets you move your object from where it’s supposed to be.
For this, we will need to use the offset to move the flag up.
""")
                                Text(".offset(y: 30)")
                                    .font(.system(.body, design: .monospaced))
                                    .padding(4)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(4)
                                    .padding(.bottom)
                                
                                Text("""
**iOS Coordinate System**
In iOS, the origin (0, 0) point is the top-left corner. Therefore, in order for the flag to move up, we have to reduce the Y offset.

You can use the `-=` operator as a shorthand for `x = x - 10`
""")
                                Text("flagOffset -= 10")
                                    .font(.system(.body, design: .monospaced))
                                    .padding(4)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(4)
                                    .padding(.bottom)
                                
                                Text("""
**Try it out!**
Using the information above, fill in the blanks below to make the flag raise.
""")
                            }
                            .padding()
                            
                            Divider()
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("""
struct MyView: View {

""")
                                    TextField("Type code here", text: $variableDeclaration)
                                        .font(.body.monospaced().bold())
                                        .padding(.leading, 42)
                                        .foregroundColor(.accentColor)
                                    Text("""

    var body: some View {
        VStack {
            HStack(alignment: .bottom, spacing: 0) {
                Rectangle()
                    .frame(width: 10)
                FlagView()
""")
                                    HStack(spacing: 0) {
                                        Text(".offset(y: ")
                                        
                                        TextField("Type code here", text: $variableName)
                                            .font(.body.monospaced().bold())
                                            .foregroundColor(.accentColor)
                                        
                                        Text(")")
                                    }
                                    .padding(.leading, 42 * 5)
                                    
                                    Text("""
            }

            Button("Raise!") {
""")
                                    TextField("Type code that executes when button pressed", text: $raiseButtonAction)
                                        .font(.body.monospaced().bold())
                                        .padding(.leading, 42 * 4)
                                        .foregroundColor(.accentColor)
                                    Text("""
            }
        }
    }
}
""")
                                }
                                .lineSpacing(8)
                                .font(.system(.body, design: .monospaced))
                                .padding()
                                .padding(.bottom)
                            }
                        }
                        
                    }
                    .navigationTitle("Raising the Flag")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        Button {
                            isIssuesPopoverPresented = true
                        } label: {
                            Image(systemName: issues.isEmpty ? "checkmark.diamond.fill" : "xmark.octagon.fill")
                                .symbolRenderingMode(.multicolor)
                        }
                        .popover(isPresented: $isIssuesPopoverPresented) {
                            List(issues, id: \.self) { issue in
                                Text(issue)
                            }
                            .frame(minWidth: flagWidth / 2, minHeight: 400)
                            .listStyle(.plain)
                            .padding(.top)
                        }
                    }
                    .onChange(of: variableDeclaration) { _ in
                        computeIssues()
                    }
                    .onChange(of: variableName) { _ in
                        computeIssues()
                    }
                    .onChange(of: raiseButtonAction) { _ in
                        computeIssues()
                    }
                    .onAppear {
                        computeIssues()
                    }
                }
                .navigationViewStyle(.stack)
                .frame(maxWidth: .infinity)
            }
            ZStack {
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.vertical)
                
                VStack {
                    Text("Flag Preview")
                        .font(.headline)
                        .padding()
                    
                    HStack(alignment: .bottom, spacing: 0) {
                        Rectangle()
                            .frame(width: 20)
                        FlagView(namespace: namespace, code: code, flagWidth: flagWidth)
                            .frame(width: 200)
                    }
                    .matchedGeometryEffect(id: "flagpole", in: namespace)
                    
                    if !enterSplitScreen {
                        HStack {
                            Button {
                                withAnimation {
                                    stage = .flagCreator
                                }
                            } label: {
                                Label("Back", systemImage: "arrow.backward")
                            }
                            .buttonStyle(.bordered)
                            
                            Spacer()
                            
                            Button {
                                withAnimation {
                                    enterSplitScreen = true
                                }
                            } label: {
                                Text("Continue")
                                Image(systemName: "arrow.forward")
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                    } else {
                        Button("Raise") {
                            withAnimation {
                                stage = .raiseFlag
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(!issues.isEmpty)
                        .matchedGeometryEffect(id: "raiseButton", in: namespace)
                    }
                }
            }
        }
    }
    
    func computeIssues() {
        issues.removeAll()
        let splitDeclaration = variableDeclaration.split(separator: " ")
        if splitDeclaration.first != "@State" {
            issues.append("The variable needs to be a @State variable.")
        }
        
        if let lastElement = splitDeclaration.last, Double(lastElement) == nil {
            issues.append("The last element needs to be of type, Double.")
        }
        
        if splitDeclaration.isEmpty {
            issues.append("The variable should be declared in the first field.")
        } else if !(5...6).contains(splitDeclaration.count) {
            issues.append("Only the variable should be declared in the first field.")
        }
        
        if !splitDeclaration.contains("var") {
            issues.append("Use var to declare a variable.")
        }
        
        if !variableDeclaration.contains("=") {
            issues.append("An = is required to assign a value.")
        }
        
        if let firstChar = variableName.first, firstChar.isNumber {
            issues.append("The variable name cannot start with a number.")
        }
        
        if variableName.filter({
            $0.isMathSymbol || $0.isWhitespace
        }).count > 0 {
            issues.append("The variable name cannot contain whitespace or math symbols.")
        }
        
        if !variableDeclaration.contains(variableName) {
            issues.append("Use of unresolved identifier: \"\(variableName)\".")
        }
        
        if !raiseButtonAction.split(separator: " ").map({String($0)}).contains(variableName) {
            issues.append("The Raise button's action should use the variable declared.")
        }
        
        if !raiseButtonAction.contains("-") {
            issues.append("The offset should be reduced in order for the flag to move up.")
        }
        
        if !(raiseButtonAction.last?.isNumber ?? false) {
            issues.append("The Raise button's action should decrement the offset by a number.")
        }
    }
}
