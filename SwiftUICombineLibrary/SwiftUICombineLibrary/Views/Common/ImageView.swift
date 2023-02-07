//
//  ImageView.swift
//  SwiftUICombineLibrary
//
//  Created by Georgi Pashov on 7.02.23.
//

import SwiftUI

struct ImageView: View {
    var imageData: Data?
    
    var body: some View {
        if let imageData = imageData, let image = UIImage(data: imageData) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
        } else {
            Image(systemName: "book")
                .foregroundColor(.gray)
        }
    }
}
