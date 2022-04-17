//
//  SFSymbolView.swift
//  
//
//  Created by Jia Chen Yee on 10/4/22.
//

import SwiftUI

struct SFSymbolView: View {
    
    @State private var searchQuery = ""
    
    @Binding var selectedSymbol: String
    
    let allSymbols = getSymbolsFromFile()
    
    @State var symbols: [String] = []
    
    var body: some View {
            ScrollView {
                LazyVGrid(columns: .init(repeating: .init(.flexible(minimum: 100, maximum: 256), spacing: 8, alignment: .top), count: 3)) {
                    ForEach(symbols, id: \.self) { symbol in
                        Button {
                            selectedSymbol = symbol
                        } label: {
                            VStack {
                                Image(systemName: symbol)
                                    .font(.title)
                                    .frame(width: 100, height: 64)
                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(selectedSymbol == symbol ? Color.accentColor : .gray))
                                    .foregroundColor(selectedSymbol == symbol ? Color.accentColor : Color(.label))
                                Text(symbol)
                                    .multilineTextAlignment(.center)
                                    .font(.caption)
                                    .frame(maxWidth: .infinity)
                            }
                            .foregroundColor(Color(.label))
                        }
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("SF Symbols")
            .searchable(text: $searchQuery, placement: .navigationBarDrawer, prompt: Text("Search Symbols"))
            .onChange(of: searchQuery) { _ in
                if !searchQuery.isEmpty {
                    symbols = allSymbols.filter {
                        $0.contains(searchQuery)
                    }
                } else {
                    symbols = allSymbols
                }
            }
            .onAppear {
                symbols = allSymbols
            }
    }
}

struct SFSymbolView_Previews: PreviewProvider {
    static var previews: some View {
        SFSymbolView(selectedSymbol: .constant(""))
    }
}
