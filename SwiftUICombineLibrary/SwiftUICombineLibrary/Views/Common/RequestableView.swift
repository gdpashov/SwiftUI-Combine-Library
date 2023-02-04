//
//  RequestableView.swift
//  SwiftUICombineLibrary
//
//  Created by Georgi Pashov on 3.02.23.
//

import SwiftUI

struct RequestableView<Content: View>: View {
    var requestable: Requestable
    @ViewBuilder
    var viewBuilder: () -> Content
    
    var body: some View {
        ZStack {
            viewBuilder()
            
            if let error = requestable.error {
                HStack {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                    
                    Text("Error: \(error.localizedDescription)")
                }
                .background(.background)
            }
            
            if requestable.isRequesting {
                ProgressView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
