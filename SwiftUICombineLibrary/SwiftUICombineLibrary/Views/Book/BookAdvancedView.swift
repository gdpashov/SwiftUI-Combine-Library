//
//  BookAdvancedView.swift
//  SwiftUICombineLibrary
//
//  Created by Georgi Pashov on 3.02.23.
//

import SwiftUI

struct BookAdvancedView: View {
    var book: OpenLibrarySearchResultBook
    
    /// Requests cover image. A progress indicator is shown while is running.
    @StateObject
    fileprivate var imageRequestViewModel: APIRequestViewModel<Data>
    
    /// Fetches the record for the book key if it exists in `FavouriteBook` Core Data entity.
    @FetchRequest
    fileprivate var fetchedFavouriteBooks: FetchedResults<FavouriteBook>
    
    init(book: OpenLibrarySearchResultBook) {
        self.book = book
        
        _imageRequestViewModel = StateObject(wrappedValue: APIRequestViewModel(urlString: book.mediumCoverImageUrlString, destinationType: Data.self))
        _fetchedFavouriteBooks = FetchRequest<FavouriteBook>(sortDescriptors: [], predicate: NSPredicate(format: "key == %@", book.key ?? ""))
    }
    
    var body: some View {
        NavigationLink {
            BookDetailView(book: book, imageRequestViewModel: imageRequestViewModel, fetchedFavouriteBooks: fetchedFavouriteBooks)
            
        } label: {
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
                    
                    IsFavouriteView(book: book, fetchedFavouriteBooks: fetchedFavouriteBooks)
                }
            }
            .padding(3.0)
        }
    }
}

struct BookAdvancedView_Previews: PreviewProvider {
    static var previews: some View {
        Text("To be implemented")
    }
}
