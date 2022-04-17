//
//  File.swift
//  
//
//  Created by Jia Chen Yee on 6/4/22.
//

import Foundation
import SwiftUI

struct NewCodeBlockMenuView: View {
    
    var onSelection: ((CodeBlock) -> ())
    
    var body: some View {
        Menu {
            Button {
                onSelection(.text)
            } label: {
                Label("Text", systemImage: "character.textbox")
            }
            
            Button {
                onSelection(.image)
            } label: {
                Label("Image", systemImage: "photo")
            }
            
            Button {
                onSelection(.vstack)
            } label: {
                Label("VStack", systemImage: "square.split.1x2")
            }
            
            Button {
                onSelection(.hstack)
            } label: {
                Label("HStack", systemImage: "square.split.2x1")
            }
            
            Button {
                onSelection(.zstack)
            } label: {
                Label("ZStack", systemImage: "square.stack")
            }
            
            Button {
                onSelection(.color)
            } label: {
                Label("Color", systemImage: "paintpalette")
            }
            
        } label: {
            Image(systemName: "plus")
                .imageScale(.large)
        }
    }
}
