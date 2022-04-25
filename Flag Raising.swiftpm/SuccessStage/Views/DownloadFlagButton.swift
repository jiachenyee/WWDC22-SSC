//
//  DownloadFlagButton.swift
//  
//
//  Created by Jia Chen Yee on 20/4/22.
//

import SwiftUI

struct DownloadFlagButton: View {
    
    var text: String
    var systemImage: String
    
    var image: UIImage
    
    @State private var isAlertPresented = false
    
    var body: some View {
        Button {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            isAlertPresented = true
        } label: {
            Label(text, systemImage: systemImage)
        }
        .alert("Image Downloaded", isPresented: $isAlertPresented, actions: {
            Button("OK", role: .cancel) {}
            Link("Open Photos", destination: URL(string: "photos-navigation://")!)
        }, message: {
            Text("An image of your flag has been saved to your Photos.")
        })
    }
}

struct DownloadFlagButton_Previews: PreviewProvider {
    static var previews: some View {
        DownloadFlagButton(text: "", systemImage: "", image: .init())
    }
}
