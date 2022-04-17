//
//  InspectorView.swift
//  
//
//  Created by Jia Chen Yee on 10/4/22.
//

import SwiftUI
import UIKit

struct InspectorView: View {
    
    @State private var toolPanelPosition = CGSize.zero
    @State private var toolSnapPosition: Alignment = .bottomLeading
    
    @ObservedObject var codingViewModel: CodingViewModel
    
    @State private var isDragging = false
    @State private var isCollapsed = false
    
    var body: some View {
        GeometryReader { context in
            VStack(spacing: 0) {
                Button {
                    withAnimation {
                        isCollapsed.toggle()
                    }
                } label: {
                    ZStack {
                        VisualEffectView(effect: UIBlurEffect(style: .systemThickMaterial))
                        
                        if isCollapsed {
                            Image(systemName: "slider.horizontal.3")
                        } else {
                            RoundedRectangle(cornerRadius: .infinity)
                                .frame(width: isDragging ? 6 : 48, height: 6)
                                .foregroundColor(.black)
                                .opacity(0.2)
                        }
                    }
                    .opacity(isDragging ? 0.7 : 1)
                }
                .frame(width: isCollapsed ? 50 : nil, height: isCollapsed ? 100 : 32)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.label), lineWidth: isCollapsed ? 0.25 : 0).opacity(0.5))
                .padding(toolSnapPosition.horizontal == .leading ? .leading : .trailing, -8)
                .highPriorityGesture(
                    DragGesture(coordinateSpace: .named("container"))
                        .onChanged { value in
                            toolPanelPosition = value.translation
                            if !isDragging {
                                withAnimation {
                                    isDragging = true
                                    isCollapsed = false
                                }
                            }
                        }
                        .onEnded { value in
                            withAnimation {
                                isDragging = false
                            }
                            windowSnappingDragEnded(value,
                                                    size: CGSize(width: 500, height: 300),
                                                    referenceSize: context.size)
                        }
                )
                
                if !isCollapsed {
                    Divider()
                    
                    NavigationView {
                        VStack {
                            if let selectedCode = codingViewModel.selectedCode {
                                InspectorOptionsView(selectedCode: Binding(get: {
                                    selectedCode
                                }, set: { newValue in
                                    let hierarchy = codingViewModel.getHierarchy(with: newValue)
                                    
                                    var newCode = newValue
                                    
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
                                    
                                    codingViewModel.selectedCode = newValue
                                }), parent: Binding(get: {
                                    codingViewModel.parent(for: selectedCode)
                                }, set: { newValue in
                                    guard let newValue = newValue else { return }
                                    let hierarchy = codingViewModel.getHierarchy(with: newValue)
                                    
                                    var newCode = newValue
                                    
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
                                }))
                                
                            } else {
                                Text("Nothing to Inspect")
                                    .font(.headline)
                                Text("Select a view in the code editor to edit it.")
                                    .font(.subheadline)
                            }
                        }
                        .navigationTitle(codingViewModel.selectedCode?.codeBlock.name ?? "Attributes Inspector")
                        .navigationBarTitleDisplayMode(.inline)
                    }
                    .navigationViewStyle(.stack)
                }
            }
            .frame(width: 400, height: context.size.height * (2 / 3), alignment: toolSnapPosition)
            .cornerRadius(isCollapsed ? 0 : 12)
            .shadow(color: .black.opacity(0.2), radius: 21)
            .padding(isCollapsed ? 0 : 16)
            .offset(toolPanelPosition)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: toolSnapPosition)
            .coordinateSpace(name: "container")
        }
    }
    
    func windowSnappingDragEnded(_ value: _ChangedGesture<DragGesture>.Value, size: CGSize, referenceSize: CGSize) {
        let referenceBounds = CGRect(origin: .zero, size: referenceSize)
        
        let endLocation = value.predictedEndLocation
        
        let maxX = referenceBounds.maxX - (endLocation.x + size.width)
        let minX = abs(endLocation.x)
        let sortedX = [maxX, minX].sorted()
        
        var horizontalAlignment: HorizontalAlignment = .center
        
        switch sortedX[0] {
        case maxX: horizontalAlignment = .trailing
        case minX: horizontalAlignment = .leading
        default: break
        }
        
        let maxY = referenceBounds.maxY - (endLocation.y + size.height)
        
        let minY = abs(endLocation.y)
        let sortedY = [maxY, minY].sorted()
        
        var verticalAlignment: VerticalAlignment = .center
        
        switch sortedY[0] {
        case maxY: verticalAlignment = .bottom
        case minY: verticalAlignment = .top
        default: break
        }
        
        let finalSnap = Alignment(horizontal: horizontalAlignment, vertical: verticalAlignment)
        
        withAnimation {
            if finalSnap.horizontal == .trailing {
                isCollapsed = endLocation.x > referenceBounds.maxX + 50
            } else {
                isCollapsed = endLocation.x < -50
            }
        }
        
        
        withAnimation {
            toolPanelPosition = .zero
            toolSnapPosition = finalSnap
        }
    }
}

struct InspectorView_Previews: PreviewProvider {
    static var previews: some View {
        InspectorView(codingViewModel: CodingViewModel())
    }
}
