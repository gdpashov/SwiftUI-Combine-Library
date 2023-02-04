//
//  BookAdvancedView.swift
//  SwiftUICombineLibrary
//
//  Created by Georgi Pashov on 3.02.23.
//

import SwiftUI

struct BookAdvancedView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var book: OpenLibrarySearchResultBook
    
    @StateObject
    fileprivate var imageRequestViewModel: APIRequestViewModel<Data>
    
    @StateObject
    fileprivate var favouriteBookViewModel: PersistanceFavouriteBookViewModel
    
    init(book: OpenLibrarySearchResultBook) {
        self.book = book
        
        _imageRequestViewModel = StateObject(wrappedValue: APIRequestViewModel(urlString: book.mediumCoverImageUrlString, destinationType: Data.self))
        _favouriteBookViewModel = StateObject(wrappedValue: PersistanceFavouriteBookViewModel(key: book.key ?? ""))
    }
    
    var body: some View {
        HStack {
            RequestableView(requestable: imageRequestViewModel) {
                ImageView(imageData: imageRequestViewModel.result)
            }
            .frame(width: 80.0)
            
            VStack(alignment: .leading, spacing: 5.0) {
                Text(book.title ?? " ")
                    .font(.body)
                    .lineLimit(2)
                
                Text((book.authorName ?? []).joined(separator: ", "))
                    .font(.subheadline)
                    .lineLimit(2)
                
                Text((book.subject ?? []).joined(separator: ", "))
                    .font(.footnote)
                    .lineLimit(2)
                
                Button {
                    favouriteBookViewModel.toggleIsFavourite()
                } label: {
                    IsFavouriteView(isFavourite: favouriteBookViewModel.isFavourite)
                }
            }
        }
        .padding(3.0)
        .onAppear {
            if favouriteBookViewModel.viewContext == nil {
                favouriteBookViewModel.viewContext = viewContext
                favouriteBookViewModel.fetch()
            }
        }
    }
}

struct BookAdvancedView_Previews: PreviewProvider {
    static var previews: some View {
        Text("To be implemented")
    }
}
