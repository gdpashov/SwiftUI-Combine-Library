//
//  HList.swift
//  SwiftUICombineLibrary
//
//  Created by Georgi Pashov on 3.02.23.
//

import SwiftUI

struct HList<Content: View>: View {
    var numberOfItems: Int
    
    var preferredItemWidth: CGFloat = 120.0
    var itemHeight: CGFloat = 190.0
    var itemSpacing: CGFloat = 15.0
    
    @ViewBuilder
    var viewBuilderForCell: (Int) -> Content
    
    var body: some View {
        GeometryReader { geometryProxy in
            let width = geometryProxy.size.width
            let visibleItemsCount = ceil(width / (preferredItemWidth + itemSpacing))
            let itemWidth = (width - visibleItemsCount * itemSpacing) / (visibleItemsCount + 0.5)
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: itemSpacing) {
                    ForEach(0 ..< numberOfItems, id: \.hashValue) { index in
                        self.viewBuilderForCell(index)
                            .frame(width: itemWidth, height: itemHeight)
                    }
                }
                .padding(.bottom, 5.0)
            }
        }
    }
}
